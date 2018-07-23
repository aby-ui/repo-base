local OptionsAppName = ...
local RangeDisplay = RangeDisplay
local ACR = LibStub("AceConfigRegistry-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local LibDualSpec = LibStub("LibDualSpec-1.0", true)
local ACD = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(OptionsAppName)

local MinFontSize = 5
local MaxFontSize = 30
local MinRangeLimit = 0
local MaxRangeLimit = 200

local lastConfiguredUd -- stupid hack to remember last open config frame
local fakeUdForProfiles = {}

local _

local function printf(fmt, ...)
    return print(fmt:format(...))
end

local FontOutlines = {
    [""] = L["None"],
    ["OUTLINE"] = L["Normal"],
    ["THICKOUTLINE"] = L["Thick"],
}

local FrameStratas = {
    ["HIGH"] = L["High"],
    ["MEDIUM"] = L["Medium"],
    ["LOW"] = L["Low"],
}

local SectionNames = {
    ["crSection"] = L["Close range section"],
    ["srSection"] = L["Short range section"],
    ["mrSection"] = L["Medium range section"],
    ["lrSection"] = L["Long range section"],
    ["defaultSection"] = L["Default section"],
    ["oorSection"] = L["Out of range section"],
}

function RangeDisplay:openConfigDialog(ud)
    ud = ud or lastConfiguredUd
    if ud then
        InterfaceOptionsFrame_OpenToCategory(ud.opts)
    else
        InterfaceOptionsFrame_OpenToCategory(self.profiles) -- to expand our tree
        InterfaceOptionsFrame_OpenToCategory(self.opts)
    end
end

function RangeDisplay:getOption(info)
    return self.db.profile[info[#info]]
end

function RangeDisplay:setOption(info, value)
    self.db.profile[info[#info]] = value
    self:applySettings()
end

local function dummy()
end

local function yes()
    return true
end

local function copyTable(src, dst)
    if type(dst) ~= "table" then dst = {} end
    if type(src) == "table" then
        for k, v in pairs(src) do
            if type(v) == "table" then
                v = copyTable(v, dst[k])
            end
            dst[k] = v
        end
    end
    return dst
end

local function getUnitOption(ud, info)
    return ud.db[info[#info]]
end

local function setUnitOption(ud, info, value)
    ud.db[info[#info]] = value
    ud:applySettings(info[#info])
end

local function getSectionOption(ud, info)
    return ud.db[info[#info - 1]][info[#info]]
end

local function setSectionOption(ud, info, value)
    ud.db[info[#info - 1]][info[#info]] = value
    ud:applySettings()
end

local function setColor(ud, dbcolor, r, g, b, a)
    dbcolor.r, dbcolor.g, dbcolor.b, dbcolor.a = r, g, b, a
    if ud.rangeFrameText then
        ud:setDisplayColor(dbcolor)
    end
end

local function getColor(ud, dbcolor)
    return dbcolor.r, dbcolor.g, dbcolor.b, dbcolor.a
end

local function getSectionColor(ud, info)
    local dbcolor =  ud.db[info[#info - 1]][info[#info]]
    return getColor(ud, dbcolor)
end

local function setSectionColor(ud, info, r, g, b, a)
    local dbcolor =  ud.db[info[#info - 1]][info[#info]]
    setColor(ud, dbcolor, r, g, b, a)
end

local function setBGColor(ud, info, r, g, b, a)
    local dbcolor = ud.db[info[#info]]
    dbcolor.r, dbcolor.g, dbcolor.b, dbcolor.a = r, g, b, a
    if not ud.bgFrame then
         return
    end
    if ud.db.bgUseSectionColors then
        ud.rangeFrameText:SetTextColor(ud.db.bgColor.r, ud.db.bgColor.g, ud.db.bgColor.b, ud.db.bgColor.a)
    else
        ud.bgFrame:SetBackdropColor(ud.db.bgColor.r, ud.db.bgColor.g, ud.db.bgColor.b, ud.db.bgColor.a)
    end
    ud.bgFrame:SetBackdropBorderColor(ud.db.bgBorderColor.r, ud.db.bgBorderColor.g, ud.db.bgBorderColor.b, ud.db.bgBorderColor.a)
end

local function getBGColor(ud, info)
    local dbcolor = ud.db[info[#info]]
    return getColor(ud, dbcolor)
end

local function isUnitDisabled(ud, info)
    return not ud.db.enabled
end

local function isSectionDisabled(ud, info)
    return (not ud.db.enabled) or (not ud.db[info[#info - 1]].enabled)
end

function RangeDisplay:updateMainOptions()
    ACR:NotifyChange(self.AppName)
end

do
    local self = RangeDisplay

    local mainOptions = {
        type = 'group',
        childGroups = 'tab',
        inline = true,
        name = RangeDisplay.AppName,
        handler = RangeDisplay,
        get = "getOption",
        set = "setOption",
        order = 10,
        args = {
            locked = {
                type = 'toggle',
                -- width = 'full',
                name = L["Locked"],
                desc = L["Lock/Unlock display frame"],
                order = 110,
                disabled = function()
                    lastConfiguredUd = nil
                    return false
                end,
            },
            mute = {
                type = 'toggle',
                -- width = 'full',
                name = L["Mute"],
                desc = L["Toggle sound"],
                order = 111,
            },
        },
    }

    local function makeSectionOptions(ud, order, section)
        local isDefault = (section == "defaultSection")
        return  {
            type = 'group',
            disabled = "isSectionDisabled",
            set = "setSectionOption",
            get = "getSectionOption",
            name = SectionNames[section],
            guiInline = true,
            order = order,
            args = {
                enabled = {
                    type = 'toggle',
                    name = "", -- L["Enabled"],
                    desc = (not isDefault) and L["Enable this color section"] or nil,
                    disabled = (not isDefault) and "isUnitDisabled" or false,
                    set = isDefault and dummy or nil,
                    get = isDefault and yes or nil,
                    width = 'half',
                    order = 10,
                },
                color = {
                    type = 'color',
                    hasAlpha = true,
                    name = L["Color"],
                    --desc = L["Color"],
                    set = "setSectionColor",
                    get = "getSectionColor",
                    width = 'half',
                    order = 20,
                },
                range = {
                    type = 'range',
                    name = L["Range limit"],
                    --desc = L["Range limit"],
                    min = MinRangeLimit,
                    max = MaxRangeLimit,
                    set = isDefault and dummy or nil,
                    get = isDefault and function() return MaxRangeLimit end or nil,
                    disabled = isDefault and true or nil,
                    step = 1,
                    order = 30,
                },
                warnSound = {
                    type = 'toggle',
                    name = L["Warning Sound"],
                    desc = L["Play a sound when entering this range"],
                    order = 60,
                },
                warnSoundName = {
                    type = "select", dialogControl = 'LSM30_Sound',
                    disabled = function() return not ud.db[section].warnSound end,
                    name = L["Warning Sound Name"],
                    values = AceGUIWidgetLSMlists.sound,
                    order = 70,
                },
                text = {
                    type = 'input',
                    name = L["Text"],
                    desc = L["The text to display for this section"],
                    -- width = 'half',
                    order = 80,
                },
            },
        }
    end

    local function makeUnitOptions(ud)
        local unit = ud.unit
        local opts = {
            type = 'group',
            name = ud.name,
            handler = ud,
            get = "getUnitOption",
            set = "setUnitOption",
            disabled = "isUnitDisabled",
            args = {
                enabled = {
                    type = 'toggle',
                    name = L["Enabled"],
                    order = 113,
                    disabled = function() 
                        lastConfiguredUd = ud
                        return false
                    end,
                },
                reverse = {
                    type = 'toggle',
                    name = L["Reverse"],
                    desc = L["Show max-min instead of min-max"],
                    order = 114,
                },
                enemyOnly = {
                    type = 'toggle',
                    name = L["Enemy only"],
                    desc = L["Show range for enemy targets only"],
                    order = 115,
                },
                warnEnemyOnly = {
                    type = 'toggle',
                    name = L["Enemy only sound"],
                    desc = L["Use warning sound for enemy targets only"],
                    order = 116,
                },
                checkVisible = {
                    type = 'toggle',
                    name = L["Check visibility"],
                    desc = L["Check if the unit is visible before doing the range check"],
                    order = 117,
                },
                sep1 = {
                    type = 'header',
                    name = "",
                    order = 119,
                },
                font = {
                    type = "select", dialogControl = 'LSM30_Font',
                    name = L["Font"],
                    --desc = L["Font"],
                    values = AceGUIWidgetLSMlists.font,
                    order = 135,
                },
                fontSize = {
                    type = 'range',
                    name = L["Font size"],
                    --desc = L["Font size"],
                    min = MinFontSize,
                    max = MaxFontSize,
                    step = 1,
                    order = 140,
                },
                fontOutline = {
                    type = 'select',
                    name = L["Font outline"],
                    --desc = L["Font outline"],
                    values = FontOutlines,
                    order = 150,
                },
                strata = {
                    type = 'select',
                    name = L["Strata"],
                    desc = L["Frame strata"],
                    values = FrameStratas,
                    order = 155,
                },
                sepBG = {
                    type = 'header',
                    name = "",
                    order = 157,
                },
                bg = {
                    type = "group",
                    name = L["Background Options"],
                    disabled = function() return not ud.db.enabled or not ud.db.bgEnabled end,
                    guiInline = true,
                    order = 158,
                    args = {
                        bgEnabled = {
                            type = 'toggle',
                            order = 1,
                            name = L["Enabled"],
                            disabled = "isUnitDisabled",
                        },
                        frameWidth = {
                            type = 'range',
                            disabled = "isUnitDisabled",
                            name = L["Width"],
                            min = 32,
                            max = 256,
                            step = 1,
                            order = 5,
                        },
                        frameHeight = {
                            type = 'range',
                            disabled = "isUnitDisabled",
                            name = L["Height"],
                            min = 16,
                            max = 64,
                            step = 1,
                            order = 6,
                        },
                        bgTexture = {
                            type = "select", dialogControl = 'LSM30_Background',
                            order = 11,
                            name = L["Background Texture"],
                            desc = L["Texture to use for the frame's background"],
                            values = AceGUIWidgetLSMlists.background,
                        },
                        bgBorderTexture = {
                            type = "select", dialogControl = 'LSM30_Border',
                            order = 12,
                            name = L["Border Texture"],
                            desc = L["Texture to use for the frame's border"],
                            values = AceGUIWidgetLSMlists.border,
                        },
                        bgColor = {
                            type = "color",
                            order = 13,
                            name = L["Background Color"],
                            desc = L["Frame's background color"],
                            hasAlpha = true,
                            set = "setBGColor",
                            get = "getBGColor",
                        },
                        bgBorderColor = {
                            type = "color",
                            order = 14,
                            name = L["Border Color"],
                            desc = L["Frame's border color"],
                            hasAlpha = true,
                            set = "setBGColor",
                            get = "getBGColor",
                        },
                        bgTile = {
                            type = "toggle",
                            order = 2,
                            name = L["Tile Background"],
                            desc = L["Tile the background texture"],
                        },
                        bgTileSize = {
                            type = "range",
                            order = 16,
                            name = L["Background Tile Size"],
                            desc = L["The size used to tile the background texture"],
                            min = 16, max = 256, step = 1,
                            disabled = function() return not ud.db.enabled or not ud.db.bgEnabled or not ud.db.bgTile end,
                        },
                        bgEdgeSize = {
                            type = "range",
                            order = 17,
                            name = L["Border Thickness"],
                            desc = L["The thickness of the border"],
                            min = 1, max = 16, step = 1,
                        },
                        bgAutoHide = {
                            type = 'toggle',
                            order = 18,
                            name = L["Auto hide"],
                            desc = L["Hide the background if the range display is not active"],
                        },
                        bgUseSectionColors = {
                            type = 'toggle',
                            order = 19,
                            name = L["Use Section Colors"],
                            desc = L["Use section colors for background and background color for text"],
                        },
                    },
                },
                sepSections = {
                    type = 'header',
                    name = "",
                    order = 190,
                },
                rangeLimit = {
                    type = 'range',
                    name = L["Range limit"],
                    desc = L["Ranges above this are not reported"],
                    min = MinRangeLimit,
                    max = MaxRangeLimit,
                    step = 1,
                    order = 191,

                },
                overLimitDisplay = {
                    type = 'toggle',
                    name = L["Over limit display"],
                    desc = L["Show/Hide display if the target is further than range limit"],
                    order = 192,
                },
                overLimitText = {
                    type = 'input',
                    name = L["Over limit text"],
                    desc = L["The text to display when you are further than range limit"],
                    order = 193,
                    disabled = function() return not ud.db.enabled or not ud.db.overLimitDisplay end,
                },
                sep2 = {
                    type = 'header',
                    name = "",
                    order = 195,
                },
                copySectionSettings = {
                    type = 'execute',
                    name = L["Copy section settings to other units"],
                    width = 'full',
                    func = function()
                        for _, oud in ipairs(RangeDisplay.units) do
                            if oud ~= ud and oud.db.enabled then
                                copyTable(ud.db.crSection, oud.db.crSection)
                                copyTable(ud.db.srSection, oud.db.srSection)
                                copyTable(ud.db.mrSection, oud.db.mrSection)
                                copyTable(ud.db.lrSection, oud.db.lrSection)
                                copyTable(ud.db.defaultSection, oud.db.defaultSection)
                                copyTable(ud.db.oorSection, oud.db.oorSection)
                            end
                        end
                    end,
                    order = 200,
                },
            },
        }

        for i, section in pairs(RangeDisplay.Sections) do
            opts.args[section] = makeSectionOptions(ud, 170 + i, section)
        end
        if ud.mouseAnchor then
            opts.args.mouseAnchor = {
                type = 'toggle',
                name = L["Anchor to Mouse"],
                order = 118,
            }
        end
        return opts
    end

    local function addConfigFunctions(units)
        for _, ud in ipairs(units) do
            ud.getUnitOption = getUnitOption
            ud.setUnitOption = setUnitOption
            ud.getSectionColor = getSectionColor
            ud.setSectionColor = setSectionColor
            ud.getSectionOption = getSectionOption
            ud.setSectionOption = setSectionOption
            ud.isUnitDisabled = isUnitDisabled
            ud.isSectionDisabled = isSectionDisabled
            ud.setBGColor = setBGColor
            ud.getBGColor = getBGColor
        end
    end

    local function registerSubOptions(name, opts)
        local appName = self.AppName .. "." .. name
        ACR:RegisterOptionsTable(appName, opts)
        return ACD:AddToBlizOptions(appName, opts.name or name, self.AppName)
    end

    -- BEGIN

    self.optionsLoaded = true

    -- remove dummy options frame, ugly hack
    if self.dummyOpts then 
        for k, f in ipairs(INTERFACEOPTIONS_ADDONCATEGORIES) do
            if f == self.dummyOpts then
                tremove(INTERFACEOPTIONS_ADDONCATEGORIES, k)
                f:SetParent(UIParent)
                break
            end
        end
        self.dummyOpts = nil
    end

    addConfigFunctions(self.units)
    ACR:RegisterOptionsTable(self.AppName, mainOptions)
    self.opts = ACD:AddToBlizOptions(self.AppName, self.AppName)
    for i, ud in ipairs(self.units) do
        local unitOpts = makeUnitOptions(ud)
        ud.opts = registerSubOptions(ud.unit, unitOpts)
    end
    local profiles =  AceDBOptions:GetOptionsTable(self.db)
    if LibDualSpec then
        LibDualSpec:EnhanceOptions(profiles, self.db)
    end
    profiles.disabled = function()
        lastConfiguredUd = fakeUdForProfiles
        return false
    end
    self.profiles = registerSubOptions('profiles', profiles)
    fakeUdForProfiles.opts = self.profiles
end

