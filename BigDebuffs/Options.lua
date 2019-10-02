local BigDebuffs = LibStub("AceAddon-3.0"):GetAddon("BigDebuffs")
local L = LibStub("AceLocale-3.0"):GetLocale("BigDebuffs")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local WarningDebuffs = {}
if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
    for i = 1, #BigDebuffs.WarningDebuffs do
        local id = BigDebuffs.WarningDebuffs[i]
        local name = GetSpellInfo(id)
        WarningDebuffs[name] = {
            type = "toggle",
            get = function(info) local key = info[#info-2] return BigDebuffs.db.profile[key].warningList[id] end,
            set = function(info, value)
                local key = info[#info-2]
                BigDebuffs.db.profile[key].warningList[id] = value BigDebuffs:Refresh()
            end,
            name = name,
            desc = L["Show this debuff if present while BigDebuffs are displayed"],
        }
    end
end

local order = {
    immunities = 1,
    immunities_spells = 2,
    cc = 3,
    buffs_defensive = 4,
    buffs_offensive = 5,
    buffs_other = 6,
    roots = 7,
}
local SpellNames = {}
local SpellIcons = {}
local Spells = {}
for spellID, spell in pairs(BigDebuffs.Spells) do
    if not spell.parent then
        Spells[spell.type] = Spells[spell.type] or {
            name = L[spell.type],
            type = "group",
            order = order[spell.type],
            args = {},
        }
        local key = "spell"..spellID
        local raidFrames = spell.type == "cc" or
            spell.type == "roots" or
            spell.type == "special" or
            spell.type == "interrupts"
        Spells[spell.type].args[key] = {
            type = "group",
            get = function(info)
                local name = info[#info]
                return BigDebuffs.db.profile.spells[spellID] and BigDebuffs.db.profile.spells[spellID][name]
            end,
            set = function(info, value)
                local name = info[#info]
                BigDebuffs.db.profile.spells[spellID] = BigDebuffs.db.profile.spells[spellID] or {}
                BigDebuffs.db.profile.spells[spellID][name] = value
                BigDebuffs:Refresh()
            end,
            name = function(info)
                local name = SpellNames[spellID] or GetSpellInfo(spellID)
                SpellNames[spellID] = name
                return name
            end,
            icon = function()
                local icon = SpellIcons[spellID] or GetSpellTexture(spellID)
                SpellIcons[spellID] = icon
                return icon
            end,
            args = {
                visibility = {
                    order = 1,
                    type = "group",
                    name = L["Visibility"],
                    inline = true,
                    get = function(info)
                        local name = info[#info]
                        local value = (BigDebuffs.db.profile.spells[spellID] and
                            BigDebuffs.db.profile.spells[spellID][name]) or
                            (not BigDebuffs.Spells[spellID]["no"..name] and 1)
                        return value and value == 1
                    end,
                    set = function(info, value)
                        local name = info[#info]
                        BigDebuffs.db.profile.spells[spellID] = BigDebuffs.db.profile.spells[spellID] or {}
                        value = value and 1 or 0
                        BigDebuffs.db.profile.spells[spellID][name] = value

                        -- unset if default visibility
                        local no = BigDebuffs.Spells[spellID]["no"..name]
                        if (value == 1 and not no) or
                            (value == 0 and no) then
                            BigDebuffs.db.profile.spells[spellID][name] = nil
                        end
                        BigDebuffs:Refresh()
                    end,
                    args = {
                        raidFrames = raidFrames and {
                            type = "toggle",
                            name = L["Raid Frames"],
                            desc = L["Show this spell on the raid frames"],
                            width = "full",
                            order = 1,
                        } or nil,
                        unitFrames = {
                            type = "toggle",
                            name = L["Unit Frames"],
                            desc = L["Show this spell on the unit frames"],
                            width = "full",
                            order = 2
                        },
                    },
                },
                priority = {
                    type = "group",
                    inline = true,
                    name = L["Priority"],
                    args = {
                        customPriority = {
                            name = L["Custom Priority"],
                            type = "toggle",
                            order = 2,
                            set = function(info, value)
                                BigDebuffs.db.profile.spells[spellID] = BigDebuffs.db.profile.spells[spellID] or {}
                                BigDebuffs.db.profile.spells[spellID].customPriority = value
                                if not value then
                                    BigDebuffs.db.profile.spells[spellID].priority = nil
                                end
                                BigDebuffs:Refresh()
                            end,
                        },
                        priority = {
                            name = L["Priority"],
                            desc = L["Higher priority spells will take precedence regardless of duration"],
                            type = "range",
                            min = 1,
                            max = 100,
                            step = 1,
                            order = 3,
                            disabled = function()
                                return not BigDebuffs.db.profile.spells[spellID] or
                                not BigDebuffs.db.profile.spells[spellID].customPriority
                            end,
                            get = function(info)
                                -- Pull the category priority
                                return BigDebuffs.db.profile.spells[spellID] and
                                    BigDebuffs.db.profile.spells[spellID].priority and
                                    BigDebuffs.db.profile.spells[spellID].priority or
                                    BigDebuffs.db.profile.priority[spell.type]
                            end,
                        },
                    },
                },

                size = raidFrames and {
                    name = L["Size"],
                    type = "group",
                    inline = true,
                    args = {
                        customSize = {
                            name = L["Custom Size"],
                            type = "toggle",
                            order = 4,
                            set = function(info, value)
                                local name = info[#info]
                                BigDebuffs.db.profile.spells[spellID] = BigDebuffs.db.profile.spells[spellID] or {}
                                BigDebuffs.db.profile.spells[spellID].customSize = value
                                if not value then
                                    BigDebuffs.db.profile.spells[spellID].size = nil
                                end
                                BigDebuffs:Refresh()
                            end,
                        },
                        size = {
                            type = "range",
                            isPercent = true,
                            name = L["Size"],
                            desc = L["Set the custom size of this spell"],
                            get = function(info)
                                -- Pull the category size
                                return BigDebuffs.db.profile.spells[spellID] and
                                    BigDebuffs.db.profile.spells[spellID].size and
                                    BigDebuffs.db.profile.spells[spellID].size/100 or
                                    BigDebuffs.db.profile.raidFrames[string.lower(spell.type)]/100
                            end,
                            set = function(info, value)
                                local name = info[#info]
                                BigDebuffs.db.profile.spells[spellID] = BigDebuffs.db.profile.spells[spellID] or {}
                                BigDebuffs.db.profile.spells[spellID][name] = value*100
                                BigDebuffs:Refresh()
                            end,
                            disabled = function() return not BigDebuffs.db.profile.spells[spellID] or
                                not BigDebuffs.db.profile.spells[spellID].customSize end,
                            min = 0,
                            max = 1,
                            step = 0.01,
                            order = 5,
                        },
                    },
                } or nil,
            },
        }
    end
end

function BigDebuffs:SetupOptions()
    self.options = {
        name = "BigDebuffs",
        descStyle = "inline",
        type = "group",
        plugins = {},
        childGroups = "tab",
        args = {
            vers = {
                order = 1,
                type = "description",
                name = "|cffffd700"..L["Version"].."|r "..GetAddOnMetadata("BigDebuffs", "Version").."\n",
                cmdHidden = true
            },
            desc = {
                order = 2,
                type = "description",
                name = "|cffffd700 "..L["Author"].."|r Jordon |cffffd700 ∑≠“Î–ﬁ∏ƒ|r NGA-“¡µÈÕ‚\n",
                cmdHidden = true
            },
            test = {
                type = "execute",
                name = L["Toggle Test Mode"],
                order = 3,
                func = "Test",
                handler = BigDebuffs,
            },
            raidFrames = {
                name = L["Raid Frames"],
                type = "group",
                disabled = function(info) return info[2] and not self.db.profile[info[1]].enabled end,
                order = 10,
                get = function(info) local name = info[#info] return self.db.profile.raidFrames[name] end,
                set = function(info, value)
                    local name = info[#info]
                    self.db.profile.raidFrames[name] = value
                    self:Refresh()
                end,
                args = {
                    enabled = {
                        type = "toggle",
                        width = "normal",
                        disabled = false,
                        name = L["Enabled"],
                        desc = L["Enable BigDebuffs on raid frames"],
                        order = 1,
                    },
                    hideBliz = {
                        type = "toggle",
                        width = "normal",
                        name = L["Hide Other Debuffs"],
                        set = function(info, value)
                            if value then
                                self.db.profile.raidFrames.redirectBliz = false
                            end
                            self.db.profile.raidFrames.hideBliz = value
                            self:Refresh()
                        end,
                        desc = L["Hides other debuffs when BigDebuffs are displayed"],
                        order = 2,
                    },
                    redirectBliz = {
                        type = "toggle",
                        width = "normal",
                        name = L["Redirect Other Debuffs"],
                        set = function(info, value)
                            if value then
                                self.db.profile.raidFrames.hideBliz = false
                            end
                            self.db.profile.raidFrames.redirectBliz = value
                            self:Refresh()
                        end,
                        desc = L["Redirects other debuffs to the BigDebuffs anchor"],
                        order = 3,
                    },
                    increaseBuffs = {
                        type = "toggle",
                        width = "double",
                        name = L["Increase Maximum Buffs"],
                        desc = L["Sets the maximum buffs to 6"],
                        order = 4,
                    },
                    cooldownCount = {
                        type = "toggle",
                        width = "normal",
                        name = L["Cooldown Count"],
                        desc = L["Allow Blizzard and other addons to display countdown text on the icons"],
                        order = 5,
                    },
                    cooldownFont = {
                        type = "select",
                        name = L["Font"],
                        desc = L["Select font for cd timers"],
                        order = 6,
                        values = function()
                            local fonts, newFonts = LibSharedMedia:List("font"), {}
                            for k, v in pairs(fonts) do
                                newFonts[v] = v
                            end
                            return newFonts
                        end,
                    },
                    cooldownFontSize = {
                        type = "range",
                        name = L["Font Size"],
                        desc = L["Set the cd timers font size"],
                        min = 1,
                        max = 30,
                        step = 1,
                        order = 7,
                    },
                    cooldownFontEffect = {
                        type = "select",
                        name = L["Font Effect"],
                        desc = L["Set the cd timers font effect"],
                        values = {
                            ["MONOCHROME"] = "MONOCHROME",
                            ["OUTLINE"] = "OUTLINE",
                            ["THICKOUTLINE"] = "THICKOUTLINE",
                            [""] = "NONE",
                        },
                        order = 7,
                    },
                    maxDebuffs = {
                        type = "range",
                        name = L["Max Debuffs"],
                        desc = L["Set the maximum number of debuffs displayed"],
                        min = 1,
                        max = 20,
                        step = 1,
                        order = 10,
                    },
                    anchor = {
                        name = L["Anchor"],
                        desc = L["Anchor to attach the BigDebuffs frames"],
                        type = "select",
                        values = {
                            ["INNER"] = L["INNER"],
                            ["LEFT"] = L["LEFT"],
                            ["RIGHT"] = L["RIGHT"],
                        },
                        order = 11,
                    },
                    scale = {
                        name = L["Size"],
                        type = "group",
                        inline = true,
                        order = 20,
                        get = function(info)
                            local name = info[#info]
                            return self.db.profile.raidFrames[name]/100
                        end,
                        set = function(info, value)
                            local name = info[#info]
                            self.db.profile.raidFrames[name] = value*100
                            self:Refresh()
                        end,
                        args = {
                            dispellable = {
                                type = "range",
                                isPercent = true,
                                name = L["Dispellable CC"],
                                desc = L["Set the size of dispellable crowd control debuffs"],
                                min = 0,
                                max = 1,
                                step = 0.01,
                                order = 1,
                                get = function(info)
                                    local name = info[#info]
                                    return self.db.profile.raidFrames.dispellable.cc/100
                                end,
                                set = function(info, value)
                                    local name = info[#info]
                                    self.db.profile.raidFrames.dispellable.cc = value*100
                                    self:Refresh()
                                end,
                            },
                            cc = {
                                type = "range",
                                isPercent = true,
                                name = L["Other CC"],
                                desc = L["Set the size of crowd control debuffs"],
                                min = 0,
                                max = 1,
                                step = 0.01,
                                order = 2,
                            },
                            dispellableRoots = {
                                type = "range",
                                isPercent = true,
                                name = L["Dispellable Roots"],
                                desc = L["Set the size of dispellable roots"],
                                min = 0,
                                max = 1,
                                step = 0.01,
                                order = 4,
                                get = function(info)
                                    local name = info[#info]
                                    return self.db.profile.raidFrames.dispellable.roots/100
                                end,
                                set = function(info, value)
                                    local name = info[#info]
                                    self.db.profile.raidFrames.dispellable.roots= value*100
                                    self:Refresh()
                                end,
                            },
                            roots = {
                                type = "range",
                                isPercent = true,
                                name = L["Other Roots"],
                                desc = L["Set the size of roots"],
                                min = 0,
                                max = 1,
                                step = 0.01,
                                order = 5,
                            },
                            default = {
                                type = "range",
                                isPercent = true,
                                name = L["Other Debuffs"],
                                desc = L["Set the size of other debuffs"],
                                min = 0,
                                max = 1,
                                step = 0.01,
                                order = 7,
                            },
                            pve = {
                                type = "range",
                                isPercent = true,
                                name = L["Dispellable PvE"],
                                desc = L["Set the size of dispellable PvE debuffs"],
                                min = 0,
                                max = 1,
                                step = 0.01,
                                order = 3,
                            },
                            interrupts = {
                                type = "range",
                                isPercent = true,
                                name = L["interrupts"],
                                desc = L["Set the size of interrupts"],
                                min = 0,
                                max = 1,
                                step = 0.01,
                                order = 8,
                            },
                        },
                    },
                    inRaid = {
                        name = L["Extras"],
                        order = 40,
                        type = "group",
                        inline = true,
                        get = function(info)
                            local name = info[#info]
                            return self.db.profile.raidFrames.inRaid[name]
                        end,
                        set = function(info, value)
                            local name = info[#info]
                            self.db.profile.raidFrames.inRaid[name] = value
                            self:Refresh()
                        end,
                        args = {
                            hide = {
                                name = L["Hide in Raids"],
                                desc = L["Hide BigDebuffs in Raids"],
                                type = "toggle",
                                order = 1
                            },
                            size = {
                                type = "range",
                                disabled = function(info)
                                    local name = info[2]
                                    return not self.db.profile.raidFrames[name].hide
                                end,
                                name = L["Group Size"],
                                desc = L["Hides BigDebuffs for groups larger than group size"],
                                width = "double",
                                min = 5,
                                max = 40,
                                step = 5,
                                order = 2
                            }
                        }
                    }

                }
            },
            unitFrames = {
                name = L["Unit Frames"],
                type = "group",
                order = 20,
                disabled = function(info) return info[2] and not self.db.profile[info[1]].enabled end,
                childGroups = "tab",
                get = function(info) local name = info[#info] return self.db.profile.unitFrames[name] end,
                set = function(info, value)
                    local name = info[#info]
                    self.db.profile.unitFrames[name] = value
                    self:Refresh()
                end,
                args = {
                    enabled = {
                        type = "toggle",
                        disabled = false,
                        width = "full",
                        name = L["Enabled"],
                        desc = L["Enable BigDebuffs on unit frames"],
                        order = 1,
                    },
                    cooldownCount = {
                        type = "toggle",
                        width = "full",
                        name = L["Cooldown Count"],
                        desc = L["Allow Blizzard and other addons to display countdown text on the icons"],
                        order = 2,
                    },
                    cooldownFont = {
                        type = "select",
                        name = L["Font"],
                        desc = L["Select font for cd timers"],
                        order = 3,
                        values = function()
                            local fonts, newFonts = LibSharedMedia:List("font"), {}
                            for k, v in pairs(fonts) do
                                newFonts[v] = v
                            end
                            return newFonts
                        end,
                    },
                    cooldownFontSize = {
                        type = "range",
                        name = L["Font Size"],
                        desc = L["Set the cd timers font size"],
                        min = 1,
                        max = 30,
                        step = 1,
                        order = 4,
                    },
                    cooldownFontEffect = {
                        type = "select",
                        name = L["Font Effect"],
                        desc = L["Set the cd timers font effect"],
                        values = {
                            ["MONOCHROME"] = "MONOCHROME",
                            ["OUTLINE"] = "OUTLINE",
                            ["THICKOUTLINE"] = "THICKOUTLINE",
                            [""] = "NONE",
                        },
                        order = 5,
                    },
                    tooltips = {
                        type = "toggle",
                        width = "full",
                        name = L["Show Tooltips"],
                        desc = L["Show spell information when mousing over the icon"],
                        order = 6,
                    },
                    player = {
                        type = "group",
                        disabled = function(info)
                            return not self.db.profile[info[1]].enabled or
                                (info[3] and not self.db.profile.unitFrames[info[2]].enabled)
                        end,
                        get = function(info)
                            local name = info[#info]
                            return self.db.profile.unitFrames.player[name]
                        end,
                        set = function(info, value)
                            local name = info[#info]
                            self.db.profile.unitFrames.player[name] = value
                            self:Refresh()
                        end,
                        args = {
                            enabled = {
                                type = "toggle",
                                disabled = function(info) return not self.db.profile[info[1]].enabled end,
                                name = L["Enabled"],
                                order = 1,
                                width = "full",
                                desc = L["Enable BigDebuffs on the player frame"],
                            },
                            anchor = {
                                name = L["Anchor"],
                                desc = L["Anchor to attach the BigDebuffs frames"],
                                type = "select",
                                values = {
                                    ["auto"] = L["Automatic"],
                                    ["manual"] = L["Manual"],
                                },
                                order = 2,
                            },
                            size = {
                                type = "range",
                                disabled = function(info)
                                    local name = info[2]
                                    return not self.db.profile.unitFrames[name].enabled or
                                        self.db.profile.unitFrames[name].anchor == "auto"
                                end,
                                name = L["Size"],
                                desc = L["Set the size of the frame"],
                                min = 8,
                                max = 512,
                                step = 1,
                                order = 3,
                            },
                        },
                        name = L["Player Frame"],
                        order = 1,
                    },
                    target = {
                        type = "group",
                        disabled = function(info)
                            return not self.db.profile[info[1]].enabled or
                                (info[3] and not self.db.profile.unitFrames[info[2]].enabled)
                        end,
                        get = function(info)
                            local name = info[#info]
                            return self.db.profile.unitFrames.target[name]
                        end,
                        set = function(info, value)
                            local name = info[#info]
                            self.db.profile.unitFrames.target[name] = value
                            self:Refresh()
                        end,
                        args = {
                            enabled = {
                                type = "toggle",
                                disabled = function(info) return not self.db.profile[info[1]].enabled end,
                                name = L["Enabled"],
                                order = 1,
                                width = "full",
                                desc = L["Enable BigDebuffs on the target frame"],
                            },
                            anchor = {
                                name = L["Anchor"],
                                desc = L["Anchor to attach the BigDebuffs frames"],
                                type = "select",
                                values = {
                                    ["auto"] = L["Automatic"],
                                    ["manual"] = L["Manual"],
                                },
                                order = 2,
                            },
                            size = {
                                type = "range",
                                disabled = function(info)
                                    local name = info[2]
                                    return not self.db.profile.unitFrames[name].enabled or
                                        self.db.profile.unitFrames[name].anchor == "auto"
                                end,
                                name = L["Size"],
                                desc = L["Set the size of the frame"],
                                min = 8,
                                max = 512,
                                step = 1,
                                order = 3,
                            },
                        },
                        name = L["Target Frame"],
                        desc = L["Enable BigDebuffs on the target frame"],
                        order = 2,
                    },
                    pet = {
                        type = "group",
                        disabled = function(info)
                            return not self.db.profile[info[1]].enabled or
                                (info[3] and not self.db.profile.unitFrames[info[2]].enabled)
                        end,
                        get = function(info)
                            local name = info[#info]
                            return self.db.profile.unitFrames.pet[name]
                        end,
                        set = function(info, value)
                            local name = info[#info]
                            self.db.profile.unitFrames.pet[name] = value
                            self:Refresh()
                        end,
                        args = {
                            enabled = {
                                type = "toggle",
                                disabled = function(info) return not self.db.profile[info[1]].enabled end,
                                name = L["Enabled"],
                                order = 1,
                                width = "full",
                                desc = L["Enable BigDebuffs on the pet frame"],
                            },
                            anchor = {
                                name = L["Anchor"],
                                desc = L["Anchor to attach the BigDebuffs frames"],
                                type = "select",
                                values = {
                                    ["auto"] = L["Automatic"],
                                    ["manual"] = L["Manual"],
                                },
                                order = 2,
                            },
                            size = {
                                type = "range",
                                disabled = function(info)
                                    local name = info[2]
                                    return not self.db.profile.unitFrames[name].enabled or
                                        self.db.profile.unitFrames[name].anchor == "auto"
                                end,
                                name = L["Size"],
                                desc = L["Set the size of the frame"],
                                min = 8,
                                max = 512,
                                step = 1,
                                order = 3,
                            },
                        },
                        name = L["Pet Frame"],
                        desc = L["Enable BigDebuffs on the pet frame"],
                        order = 4,
                    },
                    party = {
                        type = "group",
                        disabled = function(info)
                            return not self.db.profile[info[1]].enabled or
                                (info[3] and not self.db.profile.unitFrames[info[2]].enabled)
                        end,
                        get = function(info)
                            local name = info[#info]
                            return self.db.profile.unitFrames.party[name]
                        end,
                        set = function(info, value)
                            local name = info[#info]
                            self.db.profile.unitFrames.party[name] = value
                            self:Refresh()
                        end,
                        args = {
                            enabled = {
                                type = "toggle",
                                disabled = function(info) return not self.db.profile[info[1]].enabled end,
                                name = L["Enabled"],
                                order = 1,
                                width = "full",
                                desc = L["Enable BigDebuffs on the party frames"],
                            },
                            anchor = {
                                name = L["Anchor"],
                                desc = L["Anchor to attach the BigDebuffs frames"],
                                type = "select",
                                values = {
                                    ["auto"] = L["Automatic"],
                                    ["manual"] = L["Manual"],
                                },
                                order = 2,
                            },
                            size = {
                                type = "range",
                                disabled = function(info)
                                    local name = info[2]
                                    return not self.db.profile.unitFrames[name].enabled or
                                        self.db.profile.unitFrames[name].anchor == "auto"
                                end,
                                name = L["Size"],
                                desc = L["Set the size of the frame"],
                                min = 8,
                                max = 512,
                                step = 1,
                                order = 3,
                            },
                        },
                        name = L["Party Frames"],
                        desc = L["Enable BigDebuffs on the party frames"],
                        order = 5,
                    },
                    spells = {
                        order = 20,
                        name = L["Spells"],
                        type = "group",
                        inline = true,
                        args = {
                            cc = {
                                type = "toggle",
                                width = "normal",
                                name = L["cc"],
                                desc = L["Show Crowd Control on the unit frames"],
                                order = 1,
                            },
                            immunities = {
                                type = "toggle",
                                width = "normal",
                                name = L["immunities"],
                                desc = L["Show Immunities on the unit frames"],
                                order = 2,
                            },
                            interrupts = {
                                type = "toggle",
                                width = "normal",
                                name = L["interrupts"],
                                desc = L["Show Interrupts on the unit frames"],
                                order = 3,
                            },
                            immunities_spells = {
                                type = "toggle",
                                width = "normal",
                                name = L["immunities_spells"],
                                desc = L["Show Spell Immunities on the unit frames"],
                                order = 4,
                            },
                            buffs_defensive = {
                                type = "toggle",
                                width = "normal",
                                name = L["buffs_defensive"],
                                desc = L["Show Defensive Buffs on the unit frames"],
                                order = 5,
                            },
                            buffs_offensive = {
                                type = "toggle",
                                width = "normal",
                                name = L["buffs_offensive"],
                                desc = L["Show Offensive Buffs on the unit frames"],
                                order = 6,
                            },
                            buffs_other = {
                                type = "toggle",
                                width = "normal",
                                name = L["buffs_other"],
                                desc = L["Show Other Buffs on the unit frames"],
                                order = 7,
                            },
                            roots = {
                                type = "toggle",
                                width = "normal",
                                name = L["roots"],
                                desc = L["Show Roots on the unit frames"],
                                order = 8,
                            },
                        },
                    },
                }
            },
            spells = {
                name = L["Spells"],
                type = "group",
                childGroups = "tab",
                order = 40,
                args = Spells,
            },
        }
    }

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        self.options.args.raidFrames.args.warning = {
            name = L["Warning Debuffs"],
            order = 30,
            type = "group",
            inline = true,
            args = WarningDebuffs,
        }

        self.options.args.raidFrames.args.scale.args.warning = {
            type = "range",
            isPercent = true,
            name = L["Warning Debuffs"],
            desc = L["Set the size of warning debuffs"],
            min = 0,
            max = 1,
            step = 0.01,
            order = 6,
        }

        self.options.args.unitFrames.args.focus = {
            type = "group",
            disabled = function(info)
                return not self.db.profile[info[1]].enabled or
                    (info[3] and not self.db.profile.unitFrames[info[2]].enabled)
            end,
            get = function(info)
                local name = info[#info]
                return self.db.profile.unitFrames.focus[name]
            end,
            set = function(info, value)
                local name = info[#info] self.db.profile.unitFrames.focus[name] = value
                self:Refresh()
            end,
            args = {
                enabled = {
                    type = "toggle",
                    disabled = function(info)
                        return not self.db.profile[info[1]].enabled
                    end,
                    name = L["Enabled"],
                    order = 1,
                    width = "full",
                    desc = L["Enable BigDebuffs on the focus frame"],
                },
                anchor = {
                    name = L["Anchor"],
                    desc = L["Anchor to attach the BigDebuffs frames"],
                    type = "select",
                    values = {
                        ["auto"] = L["Automatic"],
                        ["manual"] = L["Manual"],
                    },
                    order = 2,
                },
                size = {
                    type = "range",
                    disabled = function(info)
                        local name = info[2]
                        return not self.db.profile.unitFrames[name].enabled or
                            self.db.profile.unitFrames[name].anchor == "auto"
                    end,
                    name = L["Size"],
                    desc = L["Set the size of the frame"],
                    min = 8,
                    max = 512,
                    step = 1,
                    order = 3,
                },
            },
            name = L["Focus Frame"],
            desc = L["Enable BigDebuffs on the focus frame"],
            order = 3,
        }

        self.options.args.unitFrames.args.arena = {
            type = "group",
            disabled = function(info)
                return not self.db.profile[info[1]].enabled or
                    (info[3] and not self.db.profile.unitFrames[info[2]].enabled)
            end,
            get = function(info)
                local name = info[#info]
                return self.db.profile.unitFrames.arena[name]
            end,
            set = function(info, value)
                local name = info[#info]
                self.db.profile.unitFrames.arena[name] = value
                self:Refresh()
            end,
            args = {
                enabled = {
                    type = "toggle",
                    disabled = function(info) return not self.db.profile[info[1]].enabled end,
                    name = L["Enabled"],
                    order = 1,
                    width = "full",
                    desc = L["Enable BigDebuffs on the arena frames"],
                },
                anchor = {
                    name = L["Anchor"],
                    desc = L["Anchor to attach the BigDebuffs frames"],
                    type = "select",
                    values = {
                        ["auto"] = L["Automatic"],
                        ["manual"] = L["Manual"],
                    },
                    order = 2,
                },
                size = {
                    type = "range",
                    disabled = function(info)
                        local name = info[2]
                        return not self.db.profile.unitFrames[name].enabled or
                        self.db.profile.unitFrames[name].anchor == "auto"
                    end,
                    name = L["Size"],
                    desc = L["Set the size of the frame"],
                    min = 8,
                    max = 512,
                    step = 1,
                    order = 3,
                },
            },
            name = L["Arena Frames"],
            desc = L["Enable BigDebuffs on the arena frames"],
            order = 6,
        }
    end

    self.options.args.priority = {
        name = L["Priority"],
        type = "group",
        get = function(info) local name = info[#info] return self.db.profile.priority[name] end,
        set = function(info, value) local name = info[#info] self.db.profile.priority[name] = value self:Refresh() end,
        order = 30,
        args = {
            immunities = {
                type = "range",
                width = "double",
                name = L["immunities"],
                desc = L["Higher priority spells will take precedence regardless of duration"],
                min = 1,
                max = 100,
                step = 1,
                order = 10,
            },
            immunities_spells = {
                type = "range",
                width = "double",
                name = L["immunities_spells"],
                desc = L["Higher priority spells will take precedence regardless of duration"],
                min = 1,
                max = 100,
                step = 1,
                order = 11,
            },
            cc = {
                type = "range",
                width = "double",
                name = L["cc"],
                desc = L["Higher priority spells will take precedence regardless of duration"],
                min = 1,
                max = 100,
                step = 1,
                order = 12,
            },
            interrupts = {
                type = "range",
                width = "double",
                name = L["interrupts"],
                desc = L["Higher priority spells will take precedence regardless of duration"],
                min = 1,
                max = 100,
                step = 1,
                order = 13,
            },
            buffs_defensive = {
                type = "range",
                width = "double",
                name = L["buffs_defensive"],
                desc = L["Higher priority spells will take precedence regardless of duration"],
                min = 1,
                max = 100,
                step = 1,
                order = 14,
            },
            buffs_offensive = {
                type = "range",
                width = "double",
                name = L["buffs_offensive"],
                desc = L["Higher priority spells will take precedence regardless of duration"],
                min = 1,
                max = 100,
                step = 1,
                order = 15,
            },
            buffs_other = {
                type = "range",
                width = "double",
                name = L["buffs_other"],
                desc = L["Higher priority spells will take precedence regardless of duration"],
                min = 1,
                max = 100,
                step = 1,
                order = 16,
            },
            roots = {
                type = "range",
                width = "double",
                name = L["roots"],
                desc = L["Higher priority spells will take precedence regardless of duration"],
                min = 1,
                max = 100,
                step = 1,
                order = 17,
            },
        },
    }

    self.options.plugins.profiles = { profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db) }

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        local LibDualSpec = LibStub('LibDualSpec-1.0')
        LibDualSpec:EnhanceDatabase(self.db, "BigDebuffsDB")
        LibDualSpec:EnhanceOptions(self.options.plugins.profiles.profiles, self.db)
    end

    LibStub("AceConfig-3.0"):RegisterOptionsTable("BigDebuffs", self.options)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BigDebuffs", "BigDebuffs")
end
