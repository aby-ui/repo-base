local _detalhes = _G._detalhes
local L = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

--> default weaktable
_detalhes.weaktable = {__mode = "v"}

--> globals
--[[global]] DETAILS_WA_AURATYPE_ICON = 1
--[[global]] DETAILS_WA_AURATYPE_TEXT = 2
--[[global]] DETAILS_WA_AURATYPE_BAR = 3

--[[global]] DETAILS_WA_TRIGGER_DEBUFF_PLAYER = 1
--[[global]] DETAILS_WA_TRIGGER_DEBUFF_TARGET = 2
--[[global]] DETAILS_WA_TRIGGER_DEBUFF_FOCUS = 3

--[[global]] DETAILS_WA_TRIGGER_BUFF_PLAYER = 4
--[[global]] DETAILS_WA_TRIGGER_BUFF_TARGET = 5
--[[global]] DETAILS_WA_TRIGGER_BUFF_FOCUS = 6

--[[global]] DETAILS_WA_TRIGGER_CAST_START = 7
--[[global]] DETAILS_WA_TRIGGER_CAST_OKEY = 8

--[[global]] DETAILS_WA_TRIGGER_DBM_TIMER = 9
--[[global]] DETAILS_WA_TRIGGER_BW_TIMER = 10

--[[global]] DETAILS_WA_TRIGGER_INTERRUPT = 11
--[[global]] DETAILS_WA_TRIGGER_DISPELL = 12

local text_dispell_prototype = {
    ["outline"] = true,
    ["fontSize"] = 24,
    ["color"] = {1, 1, 1, 1},
    ["displayText"] = "%c\n",
    ["customText"] = "function()\n    return aura_env.text\nend \n\n",
    ["untrigger"] = {
        ["custom"] = "function()\n    return not InCombatLockdown()\nend",
    },
    ["regionType"] = "text",
    ["customTextUpdate"] = "event",
    ["actions"] = {
        ["start"] = {
            ["do_custom"] = false,
            ["custom"] = "",
        },
        ["init"] = {
            ["do_custom"] = true,
            ["custom"] = "aura_env.text = \"\"\naura_env.success = 0\naura_env.dispelled = 0\naura_env.dispels_by = {}",
        },
        ["finish"] = {
        },
    },
    ["anchorPoint"] = "CENTER",
    ["additional_triggers"] = {
    },
    ["trigger"] = {
        ["spellId"] = "",
        ["message_operator"] = "==",
        ["unit"] = "player",
        ["debuffType"] = "HELPFUL",
        ["custom_hide"] = "custom",
        ["spellName"] = "",
        ["type"] = "custom",
        ["subeventSuffix"] = "_CAST_SUCCESS",
        ["custom_type"] = "event",
        ["unevent"] = "timed",
        ["use_addon"] = false,
        ["event"] = "Health",
        ["events"] = "COMBAT_LOG_EVENT_UNFILTERED, ENCOUNTER_START",
        ["use_spellName"] = false,
        ["use_spellId"] = false,
        ["custom"] = "function (event, time, token, hidding, who_serial, who_name, who_flags, who_flags2, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)\n    if (event == \"COMBAT_LOG_EVENT_UNFILTERED\") then\n        \n        if ((token == \"SPELL_DISPEL\" or token == \"SPELL_STOLEN\") and extraSpellID == 159947) then\n            aura_env.dispelled = aura_env.dispelled + 1\n            aura_env.dispels_by [who_name] = (aura_env.dispels_by [who_name] or 0) + 1\n            \n            aura_env.text = aura_env.text .. \"|cffd2e8ff\" .. who_name ..  \" (\" .. aura_env.dispels_by [who_name] .. \") \".. \"|r\\n\"\n            \n            if (select (2, aura_env.text:gsub (\"\\n\", \"\")) == 9) then\n                aura_env.text = aura_env.text:gsub (\".-\\n\", \"\", 1)\n            end\n            return true\n        end        \n    else\n        aura_env.text = \"\"\n        aura_env.success = 0\n        aura_env.dispelled = 0\n        wipe (aura_env.dispels_by)\n        return true        \n    end\nend",
        ["spellIds"] = {
        },
        ["use_message"] = true,
        ["subeventPrefix"] = "SPELL",
        ["use_unit"] = true,
        ["names"] = {},
    },
    ["justify"] = "LEFT",
    ["selfPoint"] = "BOTTOM",
    ["disjunctive"] = true,
    ["frameStrata"] = 1,
    ["width"] = 1.46286010742188,
    ["animation"] = {
        ["start"] = {
            ["type"] = "none",
            ["duration_type"] = "seconds",
        },
        ["main"] = {
            ["type"] = "none",
            ["duration_type"] = "seconds",
        },
        ["finish"] = {
            ["type"] = "none",
            ["duration_type"] = "seconds",
        },
    },
    ["font"] = "Friz Quadrata TT",
    ["numTriggers"] = 1,
    ["xOffset"] = -403.999786376953,
    ["height"] = 47.3586845397949,
    ["displayIcon"] = "Interface\\Icons\\inv_misc_steelweaponchain",
    ["load"] = {
        ["talent"] = {
            ["multi"] = {
            },
        },
        ["encounterid"] = "1721",
        ["use_encounterid"] = true,
        ["difficulty"] = {
            ["multi"] = {
            },
        },
        ["role"] = {
            ["multi"] = {
            },
        },
        ["class"] = {
            ["multi"] = {
            },
        },
        ["race"] = {
            ["multi"] = {
            },
        },
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["yOffset"] = 174.820495605469,
}

local text_interrupt_prototype = {
    ["outline"] = true,
    ["fontSize"] = 12,
    ["color"] = {1, 1, 1, 1},
    ["displayText"] = "%c\n",
    ["customText"] = "function()\n    return aura_env.text\nend \n\n",
    ["yOffset"] = 174.820495605469,
    ["anchorPoint"] = "CENTER",
    ["customTextUpdate"] = "event",
    ["actions"] = {
        ["start"] = {
            ["do_custom"] = false,
            ["custom"] = "",
        },
        ["finish"] = {
        },
        ["init"] = {
            ["do_custom"] = true,
            ["custom"] = "aura_env.text = \"\"\naura_env.success = 0\naura_env.interrupted = 0",
        },
    },
    ["untrigger"] = {
        ["custom"] = "function()\n    return not InCombatLockdown()\nend\n",
    },
    ["trigger"] = {
        ["spellId"] = "",
        ["message_operator"] = "==",
        ["subeventPrefix"] = "SPELL",
        ["unit"] = "player",
        ["debuffType"] = "HELPFUL",
        ["names"] = {},
        ["use_addon"] = false,
        ["use_unit"] = true,
        ["subeventSuffix"] = "_CAST_SUCCESS",
        ["spellName"] = "",
        ["type"] = "custom",
        ["event"] = "Health",
        ["spellIds"] = {
        },
        ["use_spellName"] = false,
        ["use_spellId"] = false,
        ["custom"] = "function (evento, time, token, hidding, who_serial, who_name, who_flags, who_flags2, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)\n    \n    if (evento == \"COMBAT_LOG_EVENT_UNFILTERED\") then\n        \n        if (token == \"SPELL_CAST_SUCCESS\" and spellid == 165416) then\n            aura_env.success = aura_env.success + 1\n            aura_env.text = aura_env.text .. \"SUCCESS! (\" .. aura_env.success .. \")\\n\"\n            \n            return true\n            \n        elseif (token == \"SPELL_INTERRUPT\" and extraSpellID == 165416) then\n            aura_env.interrupted = aura_env.interrupted + 1\n            aura_env.text = aura_env.text .. who_name ..  \" (\" .. aura_env.interrupted .. \") \".. \"\\n\"\n            return true\n        end\n    else\n        aura_env.text = \"\"\n        aura_env.success = 0\n        aura_env.interrupted = 0\n        return true        \n    end\n    \nend\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
        ["events"] = "COMBAT_LOG_EVENT_UNFILTERED, ENCOUNTER_START",
        ["use_message"] = true,
        ["unevent"] = "timed",
        ["custom_type"] = "event",
        ["custom_hide"] = "custom",
    },
    ["justify"] = "LEFT",
    ["selfPoint"] = "BOTTOM",
    ["additional_triggers"] = {
    },
    ["xOffset"] = -403.999786376953,
    ["frameStrata"] = 1,
    ["width"] = 1.46286010742188,
    ["animation"] = {
        ["start"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
        ["main"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
        ["finish"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
    },
    ["font"] = "Friz Quadrata TT",
    ["numTriggers"] = 1,
    ["height"] = 23.6792984008789,
    ["regionType"] = "text",
    ["load"] = {
        ["talent"] = {
            ["multi"] = {
            },
        },
        ["class"] = {
            ["multi"] = {
            },
        },
        ["use_encounterid"] = true,
        ["difficulty"] = {
            ["multi"] = {
            },
        },
        ["role"] = {
            ["multi"] = {
            },
        },
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["race"] = {
            ["multi"] = {
            },
        },
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["disjunctive"] = true,
}

local group_prototype_boss_mods = {
    ["grow"] = "DOWN",
    ["controlledChildren"] = {
    },
    ["borderBackdrop"] = "Blizzard Tooltip",
    ["xOffset"] = 0,
    ["yOffset"] = 0,
    ["anchorPoint"] = "CENTER",
    ["borderColor"] = {
        0, -- [1]
        0, -- [2]
        0, -- [3]
        1, -- [4]
    },
    ["space"] = 2,
    ["actions"] = {
        ["start"] = {
        },
        ["finish"] = {
        },
        ["init"] = {
        },
    },
    ["triggers"] = {
        {
            ["trigger"] = {
                ["debuffType"] = "HELPFUL",
                ["type"] = "aura2",
                ["spellIds"] = {
                },
                ["subeventSuffix"] = "_CAST_START",
                ["unit"] = "player",
                ["subeventPrefix"] = "SPELL",
                ["event"] = "Health",
                ["names"] = {
                },
            },
            ["untrigger"] = {
            },
        }, -- [1]
    },
    ["columnSpace"] = 1,
    ["radius"] = 200,
    ["selfPoint"] = "TOP",
    ["align"] = "CENTER",
    ["stagger"] = 0,
    ["subRegions"] = {
    },
    ["load"] = {
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["class"] = {
            ["multi"] = {
            },
        },
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["backdropColor"] = {
        1, -- [1]
        1, -- [2]
        1, -- [3]
        0.5, -- [4]
    },
    ["animate"] = false,
    ["arcLength"] = 360,
    ["scale"] = 1,
    ["fullCircle"] = true,
    ["border"] = false,
    ["borderEdge"] = "Square Full White",
    ["regionType"] = "dynamicgroup",
    ["borderSize"] = 2,
    ["sort"] = "none",
    ["internalVersion"] = 35,
    ["rotation"] = 0,
    ["constantFactor"] = "RADIUS",
    ["useLimit"] = false,
    ["borderOffset"] = 4,
    ["limit"] = 5,
    ["gridType"] = "RD",
    ["id"] = "Details! Boss Mods Group",
    ["borderInset"] = 1,
    ["frameStrata"] = 1,
    ["anchorFrameType"] = "SCREEN",
    ["gridWidth"] = 5,
    ["uid"] = "I7Y0mTf5KSP",
    ["rowSpace"] = 1,
    ["authorOptions"] = {
    },
    ["conditions"] = {
    },
    ["animation"] = {
        ["start"] = {
            ["easeStrength"] = 3,
            ["type"] = "none",
            ["duration_type"] = "seconds",
            ["easeType"] = "none",
        },
        ["main"] = {
            ["easeStrength"] = 3,
            ["type"] = "none",
            ["duration_type"] = "seconds",
            ["easeType"] = "none",
        },
        ["finish"] = {
            ["easeStrength"] = 3,
            ["type"] = "none",
            ["duration_type"] = "seconds",
            ["easeType"] = "none",
        },
    },
    ["config"] = {
    },
}

local group_prototype = {
    ["grow"] = "DOWN",
    ["controlledChildren"] = {
    },
    ["borderBackdrop"] = "Blizzard Tooltip",
    ["xOffset"] = 0,
    ["yOffset"] = 0,
    ["anchorPoint"] = "CENTER",
    ["borderColor"] = {
        0, -- [1]
        0, -- [2]
        0, -- [3]
        1, -- [4]
    },
    ["space"] = 2,
    ["actions"] = {
        ["start"] = {
        },
        ["finish"] = {
        },
        ["init"] = {
        },
    },
    ["triggers"] = {
        {
            ["trigger"] = {
                ["debuffType"] = "HELPFUL",
                ["type"] = "aura2",
                ["spellIds"] = {
                },
                ["subeventSuffix"] = "_CAST_START",
                ["unit"] = "player",
                ["subeventPrefix"] = "SPELL",
                ["event"] = "Health",
                ["names"] = {
                },
            },
            ["untrigger"] = {
            },
        }, -- [1]
    },
    ["columnSpace"] = 1,
    ["radius"] = 200,
    ["selfPoint"] = "TOP",
    ["align"] = "CENTER",
    ["stagger"] = 0,
    ["subRegions"] = {
    },
    ["load"] = {
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["class"] = {
            ["multi"] = {
            },
        },
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["backdropColor"] = {
        1, -- [1]
        1, -- [2]
        1, -- [3]
        0.5, -- [4]
    },
    ["animate"] = false,
    ["arcLength"] = 360,
    ["scale"] = 1,
    ["fullCircle"] = true,
    ["border"] = false,
    ["borderEdge"] = "Square Full White",
    ["regionType"] = "dynamicgroup",
    ["borderSize"] = 2,
    ["sort"] = "none",
    ["internalVersion"] = 35,
    ["rotation"] = 0,
    ["constantFactor"] = "RADIUS",
    ["useLimit"] = false,
    ["borderOffset"] = 4,
    ["limit"] = 5,
    ["gridType"] = "RD",
    ["id"] = "Details! Aura Group",
    ["borderInset"] = 1,
    ["frameStrata"] = 1,
    ["anchorFrameType"] = "SCREEN",
    ["gridWidth"] = 5,
    ["uid"] = "I7Y0mTf5KSP",
    ["rowSpace"] = 1,
    ["authorOptions"] = {
    },
    ["conditions"] = {
    },
    ["animation"] = {
        ["start"] = {
            ["easeStrength"] = 3,
            ["type"] = "none",
            ["duration_type"] = "seconds",
            ["easeType"] = "none",
        },
        ["main"] = {
            ["easeStrength"] = 3,
            ["type"] = "none",
            ["duration_type"] = "seconds",
            ["easeType"] = "none",
        },
        ["finish"] = {
            ["easeStrength"] = 3,
            ["type"] = "none",
            ["duration_type"] = "seconds",
            ["easeType"] = "none",
        },
    },
    ["config"] = {
    },
}

local bar_dbm_timerbar_prototype = {
        ["sparkWidth"] = 30,
        ["stacksSize"] = 12,
        ["xOffset"] = -102.999938964844,
        ["stacksFlags"] = "None",
        ["yOffset"] = 328.723449707031,
        ["anchorPoint"] = "CENTER",
        ["borderColor"] = {0, 0, 0, 1},
        ["rotateText"] = "NONE",
        ["backgroundColor"] = {
            0, -- [1]
            0, -- [2]
            0, -- [3]
            0.5, -- [4]
        },
        ["fontFlags"] = "OUTLINE",
        ["icon_color"] = {
            1, -- [1]
            1, -- [2]
            1, -- [3]
            1, -- [4]
        },
        ["selfPoint"] = "CENTER",
        ["barColor"] = {
            0.976470588235294, -- [1]
            0.992156862745098, -- [2]
            1, -- [3]
            0.683344513177872, -- [4]
        },
        ["desaturate"] = false,
        ["sparkOffsetY"] = 0,
        ["load"] = {
            ["difficulty"] = {
                ["multi"] = {
                },
            },
            ["race"] = {
                ["multi"] = {
                },
            },
            ["role"] = {
                ["multi"] = {
                },
            },
            ["talent"] = {
                ["multi"] = {
                },
            },
            ["class"] = {
                ["multi"] = {
                },
            },
            ["spec"] = {
                ["multi"] = {
                },
            },
            ["faction"] = {
                ["multi"] = {
                },
            },
            ["size"] = {
                ["multi"] = {
                },
            },
        },
        ["timerColor"] = {
            1, -- [1]
            1, -- [2]
            1, -- [3]
            1, -- [4]
        },
        ["regionType"] = "aurabar",
        ["stacks"] = false,
        ["sparkDesaturate"] = false,
        ["texture"] = "Blizzard Raid Bar",
        ["textFont"] = "Friz Quadrata TT",
        ["zoom"] = 0.3,
        ["spark"] = true,
        ["timerFont"] = "Friz Quadrata TT",
        ["alpha"] = 1,
        ["borderInset"] = 4,
        ["displayIcon"] = "REPLACE-ME",
        ["textColor"] = {
            1, -- [1]
            1, -- [2]
            1, -- [3]
            1, -- [4]
        },
        ["borderBackdrop"] = "Blizzard Tooltip",
        ["barInFront"] = true,
        ["sparkRotationMode"] = "AUTO",
        ["displayTextLeft"] = "REPLACE-ME",
        ["animation"] = {
            ["start"] = {
                ["duration_type"] = "seconds",
                ["type"] = "none",
            },
            ["main"] = {
                ["duration_type"] = "seconds",
                ["type"] = "none",
            },
            ["finish"] = {
                ["duration_type"] = "seconds",
                ["type"] = "none",
            },
        },
        ["trigger"] = {
            ["type"] = "custom",
            ["subeventSuffix"] = "_CAST_START",
            ["custom"] = "function() return true end",
            ["event"] = "Health",
            ["unit"] = "player",
            ["customDuration"] = "function()\n    return aura_env.reimaningTime, (aura_env.enabledAt or 0) + aura_env.reimaningTime\nend",
            ["custom_type"] = "status",
            ["spellIds"] = {
            },
            ["custom_hide"] = "timed",
            ["check"] = "update",
            ["subeventPrefix"] = "SPELL",
            ["names"] = {},
            ["debuffType"] = "HELPFUL",
        },
        ["text"] = true,
        ["stickyDuration"] = false,
        ["height"] = 40,
        ["timerFlags"] = "None",
        ["sparkBlendMode"] = "ADD",
        ["backdropColor"] = {
            0, -- [1]
            0, -- [2]
            0, -- [3]
            1, -- [4]
        },
        ["additional_triggers"] = {
            {
                ["trigger"] = {
                    ["type"] = "status",
                    ["spellId"] = "999999",
                    ["subeventSuffix"] = "_CAST_START",
                    ["use_spellId"] = true,
                    ["remaining_operator"] = "<=",
                    ["event"] = "DBM Timer",
                    ["subeventPrefix"] = "SPELL",
                    ["remaining"] = "5",
                    ["unit"] = "player",
                    ["use_unit"] = true,
                    ["unevent"] = "auto",
                    ["use_remaining"] = true,
                },
                ["untrigger"] = {
                },
            }, -- [1]
        },
        ["actions"] = {
            ["start"] = {
                ["do_custom"] = true,
                ["custom"] = "aura_env.enabledAt = GetTime()",
            },
            ["finish"] = {
            },
            ["init"] = {
                ["do_custom"] = true,
                ["custom"] = "aura_env.reimaningTime = 5",
            },
        },
        ["untrigger"] = {
        },
        ["textFlags"] = "None",
        ["border"] = false,
        ["borderEdge"] = "1 Pixel",
        ["sparkOffsetX"] = 1,
        ["borderSize"] = 1,
        ["stacksFont"] = "Friz Quadrata TT",
        ["icon_side"] = "LEFT",
        ["textSize"] = 16,
        ["timer"] = true,
        ["sparkHeight"] = 73,
        ["sparkRotation"] = 0,
        ["customTextUpdate"] = "update",
        ["stacksColor"] = {
            1, -- [1]
            1, -- [2]
            1, -- [3]
            1, -- [4]
        },
        ["displayTextRight"] = "%p",
        ["icon"] = true,
        ["inverse"] = false,
        ["frameStrata"] = 1,
        ["width"] = 450,
        ["sparkColor"] = {
            0.976470588235294, -- [1]
            0.992156862745098, -- [2]
            1, -- [3]
            0.355040311813355, -- [4]
        },
        ["timerSize"] = 16,
        ["numTriggers"] = 2,
        ["sparkDesature"] = false,
        ["orientation"] = "HORIZONTAL",
        ["borderOffset"] = 10,
        ["auto"] = true,
        ["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
}

local icon_dbm_timerbar_prototype = {
    ["xOffset"] = -110,
    ["yOffset"] = 182.978759765625,
    ["anchorPoint"] = "CENTER",
    ["customTextUpdate"] = "update",
    ["icon"] = true,
    ["fontFlags"] = "OUTLINE",
    ["selfPoint"] = "CENTER",
    ["trigger"] = {
        ["type"] = "custom",
        ["subeventSuffix"] = "_CAST_START",
        ["event"] = "Health",
        ["unit"] = "player",
        ["customDuration"] = "function()\n    return aura_env.reimaningTime, (aura_env.enabledAt or 0) + aura_env.reimaningTime\nend",
        ["custom"] = "function() return true end",
        ["spellIds"] = {
        },
        ["custom_type"] = "status",
        ["check"] = "update",
        ["subeventPrefix"] = "SPELL",
        ["names"] = {},
        ["debuffType"] = "HELPFUL",
    },
    ["desaturate"] = false,
    ["font"] = "Friz Quadrata TT",
    ["height"] = 200.170227050781,
    ["load"] = {
        ["difficulty"] = {
            ["multi"] = {
            },
        },
        ["race"] = {
            ["multi"] = {
            },
        },
        ["role"] = {
            ["multi"] = {
            },
        },
        ["talent"] = {
            ["multi"] = {
            },
        },
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["class"] = {
            ["multi"] = {
            },
        },
        ["faction"] = {
            ["multi"] = {
            },
        },
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["fontSize"] = 24,
    ["displayStacks"] = "",
    ["regionType"] = "icon",
    ["init_completed"] = 1,
    ["actions"] = {
        ["start"] = {
            ["do_custom"] = true,
            ["custom"] = "aura_env.enabledAt = GetTime()\n\n\n\n",
        },
        ["finish"] = {
        },
        ["init"] = {
            ["do_custom"] = true,
            ["custom"] = "aura_env.reimaningTime = 5",
        },
    },
    ["cooldown"] = false,
    ["stacksContainment"] = "OUTSIDE",
    ["zoom"] = 0.3,
    ["auto"] = true,
    ["additional_triggers"] = {
        {
            ["trigger"] = {
                ["type"] = "status",
                ["spellId"] = "999999",
                ["subeventSuffix"] = "_CAST_START",
                ["use_spellId"] = true,
                ["remaining_operator"] = "<=",
                ["event"] = "DBM Timer",
                ["subeventPrefix"] = "SPELL",
                ["remaining"] = "5",
                ["unit"] = "player",
                ["use_unit"] = true,
                ["unevent"] = "auto",
                ["use_remaining"] = true,
            },
            ["untrigger"] = {
            },
        }, -- [1]
    },
    ["color"] = {
        1, -- [1]
        1, -- [2]
        1, -- [3]
        1, -- [4]
    },
    ["frameStrata"] = 1,
    ["width"] = 206.000076293945,
    ["untrigger"] = {
    },
    ["inverse"] = false,
    ["numTriggers"] = 2,
    ["animation"] = {
        ["start"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
        ["main"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
        ["finish"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
    },
    ["stickyDuration"] = false,
    ["displayIcon"] = "Interface\\Icons\\Spell_Fire_Fire",
    ["stacksPoint"] = "BOTTOM",
    ["textColor"] = {
        1, -- [1]
        1, -- [2]
        1, -- [3]
        1, -- [4]
    },
}

local text_dbm_timerbar_prototype = {
    ["outline"] = true,
    ["fontSize"] = 60,
    ["color"] = {0.8, 1, 0.8, 1},
    ["displayText"] = "%c\n",
    ["customText"] = "function()\n    local at = aura_env.untrigger_at\n    if (at) then\n        return \"\" .. aura_env.ability_text .. \"\\n==>     \" .. format (\"%.1f\", at - GetTime()) .. \"     <==\"\n    else\n        return \"\"\n    end    \n    \nend\n",
    ["yOffset"] = 157.554321289063,
    ["anchorPoint"] = "CENTER",
    ["customTextUpdate"] = "update",
    ["actions"] = {
        ["start"] = {
            ["do_custom"] = true,
            ["custom"] = "aura_env.untrigger_at = GetTime() + aura_env.remaining_trigger",
        },
        ["finish"] = {
        },
        ["init"] = {
            ["do_custom"] = true,
            ["custom"] = "",
        },
    },
    ["justify"] = "CENTER",
    ["selfPoint"] = "BOTTOM",
    ["trigger"] = {
        ["remaining_operator"] = "<=",
        ["message_operator"] = "find('%s')",
        ["names"] = {},
        ["remaining"] = "6",
        ["debuffType"] = "HELPFUL",
        ["use_id"] = true,
        ["subeventSuffix"] = "_CAST_START",
        ["id"] = "Timer186333cd asd",
        ["use_remaining"] = true,
        ["event"] = "DBM Timer",
        ["unevent"] = "auto",
        ["message"] = "",
        ["use_spellId"] = false,
        ["spellIds"] = {
        },
        ["type"] = "status",
        ["use_message"] = false,
        ["unit"] = "player",
        ["use_unit"] = true,
        ["subeventPrefix"] = "SPELL",
    },
    ["untrigger"] = {
    },
    ["frameStrata"] = 1,
    ["width"] = 3.2914137840271,
    ["animation"] = {
        ["start"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
        ["main"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
        ["finish"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
    },
    ["font"] = "Friz Quadrata TT",
    ["numTriggers"] = 1,
    ["xOffset"] = -18.0000610351563,
    ["height"] = 114.000053405762,
    ["load"] = {
        ["difficulty"] = {
            ["multi"] = {
            },
        },
        ["race"] = {
            ["multi"] = {
            },
        },
        ["talent"] = {
            ["multi"] = {
            },
        },
        ["role"] = {
            ["multi"] = {
            },
        },
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["class"] = {
            ["multi"] = {
            },
        },
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["regionType"] = "text",
}

local text_prototype = {
    ["outline"] = true,
    ["fontSize"] = 12,
    ["color"] = {1, 1, 1, 1},
    ["displayText"] = "",
    ["yOffset"] = 0,
    ["anchorPoint"] = "CENTER",
    ["customTextUpdate"] = "update",
    ["actions"] = {
        ["start"] = {
        },
        ["finish"] = {
        },
        ["init"] = {
        },
    },
    ["justify"] = "LEFT",
    ["selfPoint"] = "BOTTOM",
    ["trigger"] = {
        ["type"] = "aura",
        ["spellId"] = "0",
        ["subeventSuffix"] = "_CAST_START",
        ["custom_hide"] = "timed",
        ["event"] = "Health",
        ["subeventPrefix"] = "SPELL",
        ["debuffClass"] = "magic",
        ["use_spellId"] = true,
        ["spellIds"] = {},
        ["name_operator"] = "==",
        ["fullscan"] = true,
        ["unit"] = "player",
        ["names"] = {},
        ["debuffType"] = "HARMFUL",
    },
    ["untrigger"] = {
    },
    ["frameStrata"] = 1,
    ["width"] = 31.0000057220459,
    ["animation"] = {
        ["start"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
        ["main"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
        ["finish"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
    },
    ["font"] = "Friz Quadrata TT",
    ["numTriggers"] = 1,
    ["xOffset"] = 0,
    ["height"] = 11.8704862594604,
    ["load"] = {
        ["use_combat"] = true,
        ["race"] = {
            ["multi"] = {
            },
        },
        ["talent"] = {
            ["multi"] = {
            },
        },
        ["role"] = {
            ["multi"] = {
            },
        },
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["class"] = {
            ["multi"] = {
            },
        },
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["regionType"] = "text",
}

local aurabar_prototype = {
    ["sparkWidth"] = 10,
    ["stacksSize"] = 12,
    ["xOffset"] = 0,
    ["stacksFlags"] = "None",
    ["yOffset"] = 0,
    ["anchorPoint"] = "CENTER",
    ["borderColor"] = {1, 1, 1, 0.5},
    ["rotateText"] = "NONE",
    ["backgroundColor"] = { 0, 0, 0, 0.5,},
    ["fontFlags"] = "OUTLINE",
    ["icon_color"] = {1, 1, 1, 1},
    ["selfPoint"] = "CENTER",
    ["barColor"] = {1, 0, 0, 1},
    ["desaturate"] = false,
    ["sparkOffsetY"] = 0,
    ["load"] = {
        ["use_combat"] = true,
        ["race"] = {
            ["multi"] = {
            },
        },
        ["talent"] = {
            ["multi"] = {
            },
        },
        ["role"] = {
            ["multi"] = {
            },
        },
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["class"] = {
            ["multi"] = {
            },
        },
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["timerColor"] = {1, 1, 1, 1},
    ["regionType"] = "aurabar",
    ["stacks"] = true,
    ["texture"] = "Skyline",
    ["textFont"] = "Friz Quadrata TT",
    ["zoom"] = 0,
    ["spark"] = false,
    ["timerFont"] = "Friz Quadrata TT",
    ["alpha"] = 1,
    ["borderInset"] = 11,
    ["textColor"] = {1, 1, 1, 1},
    ["borderBackdrop"] = "Blizzard Tooltip",
    ["barInFront"] = true,
    ["sparkRotationMode"] = "AUTO",
    ["displayTextLeft"] = "%n",
    ["animation"] = {
        ["start"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
        ["main"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
        ["finish"] = {
            ["duration_type"] = "seconds",
            ["type"] = "none",
        },
    },
    ["trigger"] = {
        ["type"] = "aura",
        ["spellId"] = "0",
        ["subeventSuffix"] = "_CAST_START",
        ["custom_hide"] = "timed",
        ["event"] = "Health",
        ["subeventPrefix"] = "SPELL",
        ["debuffClass"] = "magic",
        ["use_spellId"] = true,
        ["spellIds"] = {},
        ["name_operator"] = "==",
        ["fullscan"] = true,
        ["unit"] = "player",
        ["names"] = {},
        ["debuffType"] = "HARMFUL",
    },
    ["text"] = true,
    ["stickyDuration"] = false,
    ["height"] = 15,
    ["timerFlags"] = "None",
    ["sparkBlendMode"] = "ADD",
    ["backdropColor"] = {1, 1, 1, 0.5},
    ["untrigger"] = {
    },
    ["actions"] = {
        ["start"] = {
        },
        ["finish"] = {
        },
        ["init"] = {
        },
    },
    ["textFlags"] = "None",
    ["border"] = false,
    ["borderEdge"] = "None",
    ["sparkOffsetX"] = 0,
    ["borderSize"] = 16,
    ["stacksFont"] = "Friz Quadrata TT",
    ["icon_side"] = "RIGHT",
    ["textSize"] = 12,
    ["timer"] = true,
    ["sparkHeight"] = 30,
    ["sparkRotation"] = 0,
    ["customTextUpdate"] = "update",
    ["stacksColor"] = {1, 1, 1, 1},
    ["displayTextRight"] = "%p",
    ["icon"] = true,
    ["inverse"] = false,
    ["frameStrata"] = 1,
    ["width"] = 200,
    ["sparkColor"] = {1, 1, 1, 1},
    ["timerSize"] = 12,
    ["numTriggers"] = 1,
    ["sparkDesature"] = false,
    ["orientation"] = "HORIZONTAL",
    ["borderOffset"] = 5,
    ["auto"] = true,
    ["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
}

local icon_prototype = {
    {
        ["authorOptions"] = {
        },
        ["yOffset"] = 0,
        ["anchorPoint"] = "CENTER",
        ["cooldownSwipe"] = true,
        ["cooldownEdge"] = false,
        ["actions"] = {
            ["start"] = {
            },
            ["finish"] = {
            },
            ["init"] = {
            },
        },
        ["triggers"] = {
            {
                ["trigger"] = {
                    ["type"] = "aura2",
                    ["subeventSuffix"] = "_CAST_START",
                    ["event"] = "Health",
                    ["names"] = {
                    },
                    ["spellIds"] = {
                    },
                    ["auranames"] = {
                        "Aspect of the Wild", -- [1]
                    },
                    ["useName"] = true,
                    ["subeventPrefix"] = "SPELL",
                    ["unit"] = "player",
                    ["debuffType"] = "HELPFUL",
                },
                ["untrigger"] = {
                },
            }, -- [1]
            ["activeTriggerMode"] = -10,
        },
        ["internalVersion"] = 35,
        ["keepAspectRatio"] = false,
        ["animation"] = {
            ["start"] = {
                ["easeStrength"] = 3,
                ["type"] = "none",
                ["duration_type"] = "seconds",
                ["easeType"] = "none",
            },
            ["main"] = {
                ["easeStrength"] = 3,
                ["type"] = "none",
                ["duration_type"] = "seconds",
                ["easeType"] = "none",
            },
            ["finish"] = {
                ["easeStrength"] = 3,
                ["type"] = "none",
                ["duration_type"] = "seconds",
                ["easeType"] = "none",
            },
        },
        ["desaturate"] = false,
        ["subRegions"] = {
            {
                ["text_shadowXOffset"] = 0,
                ["text_text_format_s_format"] = "none",
                ["text_text"] = "%s",
                ["text_shadowColor"] = {
                    0, -- [1]
                    0, -- [2]
                    0, -- [3]
                    1, -- [4]
                },
                ["text_selfPoint"] = "AUTO",
                ["text_automaticWidth"] = "Auto",
                ["text_fixedWidth"] = 64,
                ["anchorYOffset"] = 0,
                ["text_justify"] = "CENTER",
                ["rotateText"] = "NONE",
                ["type"] = "subtext",
                ["text_color"] = {
                    1, -- [1]
                    1, -- [2]
                    1, -- [3]
                    1, -- [4]
                },
                ["text_font"] = "Friz Quadrata TT",
                ["text_shadowYOffset"] = 0,
                ["text_wordWrap"] = "WordWrap",
                ["text_visible"] = true,
                ["text_anchorPoint"] = "INNER_BOTTOMRIGHT",
                ["text_fontSize"] = 12,
                ["anchorXOffset"] = 0,
                ["text_fontType"] = "OUTLINE",
            }, -- [1]
            {
                ["glowFrequency"] = 0.25,
                ["type"] = "subglow",
                ["useGlowColor"] = false,
                ["glowType"] = "buttonOverlay",
                ["glowLength"] = 10,
                ["glowYOffset"] = 0,
                ["glowColor"] = {
                    1, -- [1]
                    1, -- [2]
                    1, -- [3]
                    1, -- [4]
                },
                ["glowXOffset"] = 0,
                ["glow"] = false,
                ["glowScale"] = 1,
                ["glowThickness"] = 1,
                ["glowLines"] = 8,
                ["glowBorder"] = false,
            }, -- [2]
        },
        ["height"] = 64,
        ["load"] = {
            ["spec"] = {
                ["multi"] = {
                },
            },
            ["class"] = {
                ["multi"] = {
                },
            },
            ["size"] = {
                ["multi"] = {
                },
            },
        },
        ["regionType"] = "icon",
        ["selfPoint"] = "CENTER",
        ["width"] = 64,
        ["frameStrata"] = 1,
        ["zoom"] = 0,
        ["auto"] = true,
        ["xOffset"] = 0,
        ["id"] = "+++Buff+++",
        ["color"] = {
            1, -- [1]
            1, -- [2]
            1, -- [3]
            1, -- [4]
        },
        ["alpha"] = 1,
        ["anchorFrameType"] = "SCREEN",
        ["icon"] = true,
        ["uid"] = "he8Lr19gc64",
        ["inverse"] = false,
        ["cooldownTextDisabled"] = false,
        ["conditions"] = {
        },
        ["cooldown"] = false,
        ["config"] = {
        },
    }
}

local actions_prototype = {
    ["start"] = {
        ["do_glow"] = true,
        ["glow_action"] = "show",
        ["do_sound"] = true,
        ["glow_frame"] = "WeakAuras:Crystalline Barrage Step",
        ["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\WaterDrop.ogg",
        ["sound_channel"] = "Master",
    },
    ["finish"] = {},
}

local debuff_prototype = {
    ["cooldown"] = false,
    ["trigger"] = {
        ["type"] = "aura2",
        ["subeventSuffix"] = "_CAST_START",
        ["event"] = "Health",
        ["names"] = {},
        ["spellIds"] = {},
        ["subeventPrefix"] = "SPELL",
        ["unit"] = "player",
        ["debuffType"] = "HARMFUL",

        ["auraspellids"] = {},
        ["useExactSpellId"] = false,
        ["auranames"] = {},
        ["useName"] = true,
    },
}

local buff_prototype = {
    ["trigger"] = {
        ["type"] = "aura2",
        ["subeventSuffix"] = "_CAST_START",
        ["event"] = "Health",
        ["names"] = {},
        ["spellIds"] = {},
        ["subeventPrefix"] = "SPELL",
        ["unit"] = "player",
        ["debuffType"] = "HELPFUL",

        ["auraspellids"] = {},
        ["useExactSpellId"] = false,
        ["auranames"] = {},
        ["useName"] = true,
    },
}

local cast_prototype = {
    ["trigger"] = {
        ["type"] = "event",
        ["spellId"] = "0",
        ["subeventSuffix"] = "_CAST_SUCCESS",
        ["unevent"] = "timed",
        ["duration"] = "4",
        ["event"] = "Combat Log",
        ["subeventPrefix"] = "SPELL",
        ["use_spellId"] = true,
    }
}

local stack_prototype = {
    ["trigger"] = {
        ["countOperator"] = ">=",
        ["count"] = "0",
        ["useCount"] = true,
    },
}

local sound_prototype = {
    ["actions"] = {
        ["start"] = {
            ["do_sound"] = true,
            ["sound"] = "Interface\\Quiet.ogg",
            ["sound_channel"] = "Master",
        },
    },
}

local sound_prototype_custom = {
    ["actions"] = {
        ["start"] = {
            ["do_sound"] = true,
            ["sound"] = " custom",
            ["sound_path"] = "Interface\\Quiet.ogg",
            ["sound_channel"] = "Master",
        },
    },
}

local chat_prototype = {
    ["actions"] = {
        ["start"] = {
            ["message"] = "",
            ["message_type"] = "SAY",
            ["do_message"] = true,
        },
    },
}

local widget_text_prototype = {
    ["fontSize"] = 20,
    ["displayStacks"] = "",
    ["stacksPoint"] = "BOTTOM",
    ["stacksContainment"] = "OUTSIDE",
}

local glow_prototype = {
    ["actions"] = {
        ["start"] = {
            ["do_glow"] = true,
            ["glow_frame"] = "",
            ["glow_action"] = "show",
        },
    },
}

function _detalhes:CreateWeakAura (aura_type, spellid, use_spellid, spellname, name, icon_texture, target, stacksize, sound, chat, icon_text, icon_glow, encounter_id, group, icon_size, other_values, in_combat, cooldown_animation)

    --print (aura_type, spellid, use_spellid, spellname, name, icon_texture, target, stacksize, sound, chat, icon_text, icon_glow, encounter_id, group, icon_size, other_values)

    --> check if wa is installed
    if (not WeakAuras or not WeakAurasSaved) then
        return
    end
    
    --> check if there is a group for our auras
--[=[
    if (not WeakAurasSaved.displays ["Details! Aura Group"]) then
        local group = _detalhes.table.copy ({}, group_prototype)
        WeakAuras.Add (group)
    end
    
    if (not WeakAurasSaved.displays ["Details! Boss Mods Group"]) then
        local group = _detalhes.table.copy ({}, group_prototype_boss_mods)
        WeakAuras.Add (group)
    end
--]=]

    if (true) then
        return Details:Msg("feature disabled due to 9.0 changes.")
    end

    --> create the icon table
    local new_aura
    icon_size = icon_size or 40
    
    if (target == 41) then -- interrupt
        
        chat = nil
        sound = nil
        icon_glow = nil
        group = nil
        
        new_aura = _detalhes.table.copy ({}, text_interrupt_prototype)
        
        new_aura.trigger.custom = [[
            function (event, time, token, hidding, who_serial, who_name, who_flags, who_flags2, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)
                if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
                    if (token == "SPELL_CAST_SUCCESS" and spellid == @spellid) then
                        aura_env.success = aura_env.success + 1
                        aura_env.text = aura_env.text .. "|cffffc5c5@spell_casted (" .. aura_env.success .. ")|r\n"
                    elseif (token == "SPELL_INTERRUPT" and extraSpellID == @spellid) then
                        aura_env.interrupted = aura_env.interrupted + 1
                        aura_env.text = aura_env.text .. "|cffc5ffc5" .. who_name ..  " (" .. aura_env.interrupted .. ") ".. "|r\n"
                    end
                    if (select (2, aura_env.text:gsub ("\n", "")) == 9) then
                        aura_env.text = aura_env.text:gsub (".-\n", "", 1)
                    end
                    return true
                else
                    aura_env.text = ""
                    aura_env.success = 0
                    aura_env.interrupted = 0
                    return true        
                end
            end
        ]]
        
        new_aura.trigger.custom = new_aura.trigger.custom:gsub ("@spellid", spellid)
        new_aura.trigger.custom = new_aura.trigger.custom:gsub ("@spell_casted", icon_text)
        
        --> size
        new_aura.fontSize = min (icon_size, 24)
        
        --> combat only
        if (in_combat) then
            new_aura.load.use_combat = true
        else
            new_aura.load.use_combat = nil
        end
        
    elseif (target == 42) then -- dispell
    
        chat = nil
        sound = nil
        icon_glow = nil
        group = nil
        
        new_aura = _detalhes.table.copy ({}, text_dispell_prototype)
        
        new_aura.trigger.custom = [[
            function (event, time, token, hidding, who_serial, who_name, who_flags, who_flags2, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)
                if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
                    if ((token == "SPELL_DISPEL" or token == "SPELL_STOLEN") and extraSpellID == @spellid) then
                        aura_env.dispelled = aura_env.dispelled + 1
                        aura_env.dispels_by [who_name] = (aura_env.dispels_by [who_name] or 0) + 1
                        aura_env.text = aura_env.text .. "|cffd2e8ff" .. who_name ..  " (" .. aura_env.dispels_by [who_name] .. ") ".. "|r\n"

                        if (select (2, aura_env.text:gsub ("\n", "")) == 11) then
                            aura_env.text = aura_env.text:gsub (".-\n", "", 2)
                            aura_env.text = "@title\n" .. aura_env.text
                        end
                        return true
                    end
                else
                    aura_env.text = "@title\n"
                    aura_env.success = 0
                    aura_env.dispelled = 0
                    wipe (aura_env.dispels_by)
                    return true
                end
            end
        ]]
        
        new_aura.trigger.custom = new_aura.trigger.custom:gsub ("@spellid", spellid)
        new_aura.trigger.custom = new_aura.trigger.custom:gsub ("@title", icon_text)

        --> size
        new_aura.fontSize = min (icon_size, 24)
    
        --> combat only
        if (in_combat) then
            new_aura.load.use_combat = true
        else
            new_aura.load.use_combat = nil
        end
    
    elseif (other_values.dbm_timer_id or other_values.bw_timer_id) then --boss mods
    
        --> create the default aura table
        if (aura_type == "icon") then
            new_aura = _detalhes.table.copy ({}, icon_dbm_timerbar_prototype)
        elseif (aura_type == "aurabar") then
            new_aura = _detalhes.table.copy ({}, bar_dbm_timerbar_prototype)
        elseif (aura_type == "text") then
            new_aura = _detalhes.table.copy ({}, text_dbm_timerbar_prototype)
        end

        --> text and icon
        if (aura_type == "aurabar") then
            icon_text = icon_text:gsub ("= ", "")
            icon_text = icon_text:gsub (" =", "")
            icon_text = icon_text:gsub ("=", "")
            new_aura.displayTextLeft = icon_text
            new_aura.displayIcon = icon_texture
        elseif (aura_type == "icon") then
            new_aura.displayStacks = icon_text
            new_aura.displayIcon = icon_texture
        end
        
        --> size
        if (aura_type == "icon") then
            new_aura.width = icon_size
            new_aura.height = icon_size
        elseif (aura_type == "aurabar") then
            new_aura.width = max (icon_size, 370)
            new_aura.height = 38
        elseif (aura_type == "text") then
            new_aura.fontSize = min (icon_size, 72)
        end
        
        --> trigger
        if (aura_type == "text") then
            local init_start = [[
                aura_env.ability_text = "@text"
                aura_env.remaining_trigger = @countdown
            ]]

            init_start = init_start:gsub ("@text", icon_text)
            init_start = init_start:gsub ("@countdown", floor (stacksize))
            new_aura.trigger.remaining = tostring (floor (stacksize))
            new_aura.actions.init.custom = init_start

            if (other_values.dbm_timer_id) then
                new_aura.trigger.event = "DBM Timer"
                local timerId = tostring (other_values.dbm_timer_id)
                
                --print ("timerId:", other_values.dbm_timer_id, type (other_values.dbm_timer_id), timerId:find ("%s"))
                --other_values.spellid
                
                --if (timerId:find ("%s")) then
                    --spellid timers
                    new_aura.trigger.id = ""
                    new_aura.trigger.use_id = false
                    new_aura.trigger.spellId_operator = "=="
                    new_aura.trigger.use_spellId = true
                    new_aura.trigger.spellId = tostring (other_values.spellid)
                --else
                    --ej timers
                --	new_aura.trigger.id = timerId
                --end
            elseif (other_values.bw_timer_id) then
                new_aura.trigger.id = ""
                new_aura.trigger.use_id = false
                new_aura.trigger.spellId_operator = "=="
                new_aura.trigger.use_spellId = true
                new_aura.trigger.spellId = tostring (other_values.bw_timer_id)
                new_aura.trigger.event = "BigWigs Timer"
            end
            
        elseif (aura_type == "aurabar" or aura_type == "icon") then
            local trigger = new_aura.additional_triggers[1].trigger
            
            local init_start = [[
                aura_env.reimaningTime = @countdown
            ]]
            init_start = init_start:gsub ("@countdown", floor (stacksize))
            trigger.remaining = tostring (floor (stacksize))
            new_aura.actions.init.custom = init_start
            
            if (other_values.dbm_timer_id) then
                trigger.event = "DBM Timer"
                trigger.spellId = tostring (other_values.spellid)
                
            elseif (other_values.bw_timer_id) then
                trigger.event = "BigWigs Timer"
                trigger.spellId = tostring (other_values.bw_timer_id)
                trigger.spellId_operator = "=="
            end
        end
        
    else
    
        if (aura_type == "icon") then
            new_aura = _detalhes.table.copy ({}, icon_prototype)
        elseif (aura_type == "aurabar") then
            new_aura = _detalhes.table.copy ({}, aurabar_prototype)
        elseif (aura_type == "text") then
            new_aura = _detalhes.table.copy ({}, text_prototype)
            new_aura.displayText = spellname
        end
    
        if (target) then
            if (target == 1) then --Debuff on Player
                local add = _detalhes.table.copy ({}, debuff_prototype)
                add.trigger.spellId = tostring (spellid)
                add.trigger.spellIds[1] = "" --spellid
                add.trigger.names  = nil --spellname
                add.trigger.auranames = {tostring(spellid)}
                add.trigger.unit = "player"
                add.trigger.useName = true
                add.trigger.type = "aura2"
                add.trigger.matchesShowOn = "showOnActive"
                add.trigger.unitExists = false
                add.trigger.name_operator = nil
                add.trigger.genericShowOn = "showOnActive"
                add.trigger.debuffClass = nil


                _detalhes.table.overwrite (new_aura, add)
                
            elseif (target == 2) then --Debuff on Target
                local add = _detalhes.table.copy ({}, debuff_prototype)
                add.trigger.spellId = tostring (spellid)
                add.trigger.spellIds[1] = "" --spellid
                add.trigger.names = nil --spellname
                add.trigger.auranames = {tostring(spellid)}
                add.trigger.unit = "target"
                add.trigger.useName = true
                add.trigger.type = "aura2"
                add.trigger.matchesShowOn = "showOnActive"
                add.trigger.unitExists = false
                add.trigger.name_operator = nil
                add.trigger.genericShowOn = "showOnActive"
                add.trigger.debuffClass = nil
                
                --set as own only to avoid being active by other players
                add.trigger.ownOnly = true
                
                _detalhes.table.overwrite (new_aura, add)

            elseif (target == 3) then --Debuff on Focus
                local add = _detalhes.table.copy ({}, debuff_prototype)
                add.trigger.spellId = tostring (spellid)
                add.trigger.spellIds[1] = "" --spellid
                add.trigger.names = nil --spellname
                add.trigger.auranames = {tostring(spellid)}
                add.trigger.unit = "focus"
                add.trigger.useName = true
                add.trigger.type = "aura2"
                add.trigger.matchesShowOn = "showOnActive"
                add.trigger.unitExists = false
                add.trigger.name_operator = nil
                add.trigger.genericShowOn = "showOnActive"
                add.trigger.debuffClass = nil

                _detalhes.table.overwrite (new_aura, add)
                
            elseif (target == 11) then --Buff on Player
                local add = _detalhes.table.copy ({}, buff_prototype)
                add.trigger.names = nil --spellname
                add.trigger.unit = "player"
                add.trigger.useName = true
                add.trigger.type = "aura2"
                add.trigger.matchesShowOn = "showOnActive"
                add.trigger.unitExists = false
                add.trigger.name_operator = nil
                add.trigger.genericShowOn = "showOnActive"
                add.trigger.debuffClass = nil

                _detalhes.table.overwrite (new_aura, add)
                
            elseif (target == 12) then --Buff on Target
                local add = _detalhes.table.copy ({}, buff_prototype)
                add.trigger.spellId = tostring (spellid)
                add.trigger.spellIds[1] = "" --spellid
                add.trigger.names = nil --spellname
                add.trigger.unit = "target"
                add.trigger.type = "aura2"
                add.trigger.matchesShowOn = "showOnActive"
                add.trigger.unitExists = false
                add.trigger.name_operator = nil
                add.trigger.genericShowOn = "showOnActive"
                add.trigger.debuffClass = nil

                _detalhes.table.overwrite (new_aura, add)
                
            elseif (target == 13) then --Buff on Focus
                local add = _detalhes.table.copy ({}, buff_prototype)
                add.trigger.spellId = tostring (spellid)
                add.trigger.spellIds[1] = "" --spellid
                add.trigger.names = nil --spellname
                add.trigger.auranames = {tostring(spellid)}
                add.trigger.unit = "focus"
                add.trigger.useName = true
                add.trigger.type = "aura2"
                add.trigger.matchesShowOn = "showOnActive"
                add.trigger.unitExists = false
                add.trigger.name_operator = nil
                add.trigger.genericShowOn = "showOnActive"
                add.trigger.debuffClass = nil

                _detalhes.table.overwrite (new_aura, add)
                
            elseif (target == 21) then --Spell Cast Started
                local add = _detalhes.table.copy ({}, cast_prototype)
                add.trigger.spellId = tostring (spellid)
                add.trigger.spellName = spellname
                add.trigger.subeventSuffix = "_CAST_START"
                add.trigger.duration = stacksize
                if (not use_spellid) then
                    add.trigger.use_spellName = true
                    add.trigger.use_spellId = false
                end
                _detalhes.table.overwrite (new_aura, add)
                
            elseif (target == 22) then --Spell Cast Successful
                local add = _detalhes.table.copy ({}, cast_prototype)
                add.trigger.spellId = tostring (spellid)
                add.trigger.spellName = spellname
                if (not use_spellid) then
                    add.trigger.use_spellName = true
                    add.trigger.use_spellId = false
                end
                _detalhes.table.overwrite (new_aura, add)
            end
            
            --> combat only
            if (in_combat) then
                new_aura.load = new_aura.load or {}
                new_aura.load.use_combat = true
            else
                new_aura.load.use_combat = nil
            end

        else
            new_aura.trigger.spellId = tostring (spellid)
            new_aura.trigger.name = spellname
            tinsert (new_aura.trigger.spellIds, spellid)
        end
        
        --> if is a regular aura without using spells ids
        if (not use_spellid) then
            new_aura.trigger.useExactSpellId = false
            new_aura.useName = true
            new_aura.auranames = {spellname}
        else
            new_aura.trigger.useExactSpellId = true
            new_aura.useName = false
            new_aura.auraspellids = {tostring(spellid)}
        end
        
        --> check stack size
        if (stacksize and stacksize >= 1) then
            stacksize = floor (stacksize)
            local add = _detalhes.table.copy ({}, stack_prototype)
            add.trigger.count = tostring (stacksize)
            _detalhes.table.overwrite (new_aura, add)
        end
        
        --> icon text
        if (icon_text and icon_text ~= "") then
            if (aura_type == "text") then
                new_aura.displayText = icon_text
            else
                local add = _detalhes.table.copy ({}, widget_text_prototype)
                add.displayStacks = icon_text
                _detalhes.table.overwrite (new_aura, add)
            end
        end
        
        --> size
        if (aura_type == "icon") then
            new_aura.width = icon_size
            new_aura.height = icon_size
        elseif (aura_type == "aurabar") then
            new_aura.width = min (icon_size, 250)
            new_aura.height = 24
        elseif (aura_type == "text") then
            new_aura.fontSize = min (icon_size, 24)
        end
    end
    
    new_aura.id = name
    new_aura.displayIcon = icon_texture		

    --> load by encounter id
    if (encounter_id) then
        new_aura.load = new_aura.load or {}
        new_aura.load.use_encounterid = true
        new_aura.load.encounterid = tostring (encounter_id)
    end

    --> using sound
    if (sound and type (sound) == "table") then
        local add = _detalhes.table.copy ({}, sound_prototype_custom)
        add.actions.start.sound_path = sound.sound_path
        add.actions.start.sound_channel = sound.sound_channel or "Master"
        _detalhes.table.overwrite (new_aura, add)
        
    elseif (sound and sound ~= "" and not sound:find ("Quiet.ogg")) then
        local add = _detalhes.table.copy ({}, sound_prototype)
        add.actions.start.sound = sound
        _detalhes.table.overwrite (new_aura, add)
    end
    
    --> chat message
    if (chat and chat ~= "") then
        local add = _detalhes.table.copy ({}, chat_prototype)
        add.actions.start.message = chat
        _detalhes.table.overwrite (new_aura, add)
    end
    
    --> check if already exists a aura with this name
    if (WeakAurasSaved.displays [new_aura.id]) then
        for i = 2, 100 do
            if (not WeakAurasSaved.displays [new_aura.id .. " (" .. i .. ")"]) then
                new_aura.id = new_aura.id .. " (" .. i .. ")"
                break
            end
        end
    end
    
    --> check is is using glow effect
    if (icon_glow) then
        local add = _detalhes.table.copy ({}, glow_prototype)
        add.actions.start.glow_frame = "WeakAuras:" .. new_aura.id
        _detalhes.table.overwrite (new_aura, add)
    end
    
    if (cooldown_animation) then
        new_aura.cooldown = true
        new_aura.cooldownTextEnabled = true
    end
    
    --> add the aura on a group
    if (group) then
        new_aura.parent = group
        
        if (new_aura.regionType == "icon") then
            --> adjust the width and height of the new aura following the existing auras on the group
            local normalWidth, normalHeight, amount = 0, 0, 0
            local allAurasInTheGroup = WeakAurasSaved.displays [group].controlledChildren
            
            for index, auraname in ipairs (allAurasInTheGroup) do
                local auraObject = WeakAurasSaved.displays [auraname]
                if (auraObject and auraObject.regionType == "icon") then
                    amount = amount + 1
                    normalWidth = normalWidth + auraObject.width
                    normalHeight = normalHeight + auraObject.height
                end
            end
            
            if (normalWidth > 0) then
                normalWidth = normalWidth / amount
                normalHeight = normalHeight / amount
                new_aura.width = normalWidth
                new_aura.height = normalHeight
            end
        end
        
        tinsert (WeakAurasSaved.displays [group].controlledChildren, new_aura.id)
    else
        new_aura.parent = nil
    end
    
    --> add the aura
    WeakAuras.Add (new_aura)
    
    --> check if the options panel has loaded
    local options_frame = WeakAuras.OptionsFrame and WeakAuras.OptionsFrame()
    if (options_frame) then
        if (options_frame and not options_frame:IsShown()) then
            WeakAuras.ToggleOptions()
        end
        WeakAuras.NewDisplayButton (new_aura)
    end

end


-- other_values DBM:
-- text_size 72
-- dbm_timer_id Timer183254cd
-- text Next Allure of Flames In
-- spellid 183254
-- icon Interface\Icons\Spell_Fire_FelFlameStrike

-- other_values BW:
-- bw_timer_id 183828
-- text Next Death Brand In
-- icon Interface\Icons\warlock_summon_doomguard
-- text_size 72

function _detalhes:InitializeAuraCreationWindow()
    local DetailsAuraPanel = CreateFrame ("frame", "DetailsAuraPanel", UIParent,"BackdropTemplate")
    DetailsAuraPanel.Frame = DetailsAuraPanel
    DetailsAuraPanel.__name = L["STRING_CREATEAURA"]
    DetailsAuraPanel.real_name = "DETAILS_CREATEAURA"
    
    if (_G.WeakAuras) then 
        DetailsAuraPanel.__icon = [[Interface\AddOns\WeakAuras\Media\Textures\icon]]
    else
        DetailsAuraPanel.__icon = [[Interface\BUTTONS\UI-GroupLoot-DE-Up]]
    end
    
    DetailsPluginContainerWindow.EmbedPlugin (DetailsAuraPanel, DetailsAuraPanel, true)

    function DetailsAuraPanel.RefreshWindow()
        _detalhes:OpenAuraPanel() --spellid, spellname, spellicon, encounterid, triggertype, auratype, other_values
    end
end

local empty_other_values = {}
function _detalhes:OpenAuraPanel (spellid, spellname, spellicon, encounterid, triggertype, auratype, other_values)
    
    if (not spellname) then
        spellname = select (1, GetSpellInfo (spellid))
    end

    wipe (empty_other_values)
    other_values = other_values or empty_other_values
    
    if (not DetailsAuraPanel or not DetailsAuraPanel.Initialized) then
        
        DetailsAuraPanel.Initialized = true
        
        --> check if there is a group for our auras
        if (WeakAuras and WeakAurasSaved) then
            if (not WeakAurasSaved.displays ["Details! Aura Group"]) then
                local group = _detalhes.table.copy ({}, group_prototype)
                WeakAuras.Add (group)
            end
            if (not WeakAurasSaved.displays ["Details! Boss Mods Group"]) then
                local group = _detalhes.table.copy ({}, group_prototype_boss_mods)
                WeakAuras.Add (group)
            end
        end

        local f = DetailsAuraPanel or CreateFrame ("frame", "DetailsAuraPanel", UIParent,"BackdropTemplate")
        f:SetSize (800, 600)
        f:SetPoint ("center", UIParent, "center", 0, 150)
        f:SetFrameStrata ("DIALOG")
        f:EnableMouse (true)
        f:SetMovable (true)
        f:SetToplevel (true)
        
        --background
        f.bg1 = f:CreateTexture (nil, "background")
        f.bg1:SetTexture ([[Interface\AddOns\Details\images\background]], true)
        f.bg1:SetAlpha (0.8)
        f.bg1:SetVertexColor (0.27, 0.27, 0.27)
        f.bg1:SetVertTile (true)
        f.bg1:SetHorizTile (true)
        f.bg1:SetSize (790, 454)
        f.bg1:SetAllPoints()
        f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
        f:SetBackdropColor (.5, .5, .5, .7)
        f:SetBackdropBorderColor (0, 0, 0, 1)
        
        --register to libwindow
        local LibWindow = LibStub ("LibWindow-1.1")
        LibWindow.RegisterConfig (f, _detalhes.createauraframe)
        LibWindow.RestorePosition (f)
        LibWindow.MakeDraggable (f)
        LibWindow.SavePosition (f)
        
        f:SetScript ("OnMouseDown", function (self, button)
            if (button == "RightButton") then
                f:Hide()
            end
        end)
        
        --titlebar
        f.TitleBar = CreateFrame ("frame", "$parentTitleBar", f,"BackdropTemplate")
        f.TitleBar:SetPoint ("topleft", f, "topleft", 2, -3)
        f.TitleBar:SetPoint ("topright", f, "topright", -2, -3)
        f.TitleBar:SetHeight (20)
        f.TitleBar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
        f.TitleBar:SetBackdropColor (.2, .2, .2, 1)
        f.TitleBar:SetBackdropBorderColor (0, 0, 0, 1)
        
        --close button
        f.Close = CreateFrame ("button", "$parentCloseButton", f, "BackdropTemplate")
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
        f.Title:SetText ("Details! Create Aura")

        local fw = _detalhes:GetFramework()
        
        local text_template = fw:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
        local dropdown_template = fw:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
        local switch_template = fw:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
        local slider_template = fw:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
        local button_template = fw:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
        
        --aura name
        local name_label = fw:CreateLabel (f, "Aura Name: ", nil, nil, "GameFontNormal")
        local name_textentry = fw:CreateTextEntry (f, _detalhes.empty_function, 150, 20, "AuraName", "$parentAuraName")
        name_textentry:SetTemplate (slider_template)
        name_textentry:SetPoint ("left", name_label, "right", 2, 0)
        f.name = name_textentry
        
        --aura type
        local on_select_aura_type = function (_, _, aura_type)
            if (f.UpdateLabels) then
                f:UpdateLabels()
            end
        end
        local aura_type_table = {
            {label = "Icon", value = "icon", onclick = on_select_aura_type}, --, icon = aura_on_icon
            {label = "Text", value = "text", onclick = on_select_aura_type},
            {label = "Progress Bar", value = "aurabar", onclick = on_select_aura_type},
        }
        local aura_type_options = function()
            return aura_type_table
        end
        local aura_type = fw:CreateDropDown (f, aura_type_options, 1, 150, 20, "AuraTypeDropdown", "$parentAuraTypeDropdown")
        local aura_type_label = fw:CreateLabel (f, "Aura Type: ", nil, nil, "GameFontNormal")
        aura_type:SetPoint ("left", aura_type_label, "right", 2, 0)
        aura_type:Hide()
        
        local Icon_IconAuraType = fw:CreateImage (f, [[Interface\AddOns\Details\images\icons2]], 32, 32, "overlay", {200/512, 232/512, 336/512, 368/512}, nil, nil)
        Icon_IconAuraType:SetPoint ("topleft", aura_type_label, "bottomleft", 10, -16)
        
        local Icon_StatusbarAuraType = fw:CreateImage (f, [[Interface\AddOns\Details\images\icons2]], 92, 12, "overlay", {235/512, 327/512, 336/512, 348/512}, nil, nil)
        Icon_StatusbarAuraType:SetPoint ("topleft", aura_type_label, "bottomleft", 60, -26)
        
        local Icon_TextOnlyAuraType = fw:CreateImage (f, [[Interface\AddOns\Details\images\icons2]], 57, 8, "overlay", {250/512, 306/512, 360/512, 367/512}, nil, nil)
        Icon_TextOnlyAuraType:SetPoint ("topleft", aura_type_label, "bottomleft", 170, -28)
        
        local AuraTypeSelectedColor = {1, 1, 1, 0.3}
        local AuraTypeBorderColor = {.3, .3, .3, 0.5}
        local AuraTypeBorderSelectedColor = {1, 1, 1, 0.4}
        
        local OnSelectAuraType = function (self, fixedParam, auraType, noUpdate)
        
            if (type (auraType) == "number") then
                if (auraType == 1) then
                    auraType = "icon"
                elseif (auraType == 2) then
                    auraType = "text"
                elseif (auraType == 3) then
                    auraType = "aurabar"
                end
            end
            
            f.IconAuraTypeButton:SetBackdropColor (0, 0, 0, 0.05)
            f.StatusbarAuraTypeButton:SetBackdropColor (0, 0, 0, 0.05)
            f.TextOnlyAuraTypeButton:SetBackdropColor (0, 0, 0, 0.05)
            
            f.IconAuraTypeButton:SetBackdropBorderColor (unpack (AuraTypeBorderColor))
            f.StatusbarAuraTypeButton:SetBackdropBorderColor (unpack (AuraTypeBorderColor))
            f.TextOnlyAuraTypeButton:SetBackdropBorderColor (unpack (AuraTypeBorderColor))
            
            if (auraType == "icon") then
                f.IconAuraTypeButton:SetBackdropColor (unpack (AuraTypeSelectedColor))
                f.IconAuraTypeButton:SetBackdropBorderColor (unpack (AuraTypeBorderSelectedColor))
            elseif (auraType == "aurabar") then
                f.StatusbarAuraTypeButton:SetBackdropColor (unpack (AuraTypeSelectedColor))
                f.StatusbarAuraTypeButton:SetBackdropBorderColor (unpack (AuraTypeBorderSelectedColor))
            elseif (auraType == "text") then
                f.TextOnlyAuraTypeButton:SetBackdropColor (unpack (AuraTypeSelectedColor))
                f.TextOnlyAuraTypeButton:SetBackdropBorderColor (unpack (AuraTypeBorderSelectedColor))
            end
            
            aura_type:SetValue (auraType)
            if (f.UpdateLabels and not noUpdate) then
                f:UpdateLabels()
            end
        end
        f.OnSelectAuraType = OnSelectAuraType
        
        local AuraTypeBackground = f:CreateTexture (nil, "border")
        AuraTypeBackground:SetColorTexture (.4, .4, .4, .1)
        AuraTypeBackground:SetHeight (64)
        AuraTypeBackground:SetPoint ("topleft", f, "topleft", 10, -79)
        AuraTypeBackground:SetPoint ("topright", f, "topright", -10, -79)
        
        local Icon_IconAuraTypeButton = fw:CreateButton (f, OnSelectAuraType, 46, 46, "", "icon", nil, nil, "IconAuraTypeButton")
        local Icon_StatusbarAuraTypeButton = fw:CreateButton (f, OnSelectAuraType, 100, 46, "", "aurabar", nil, nil, "StatusbarAuraTypeButton")
        local Icon_TextOnlyAuraTypeButton = fw:CreateButton (f, OnSelectAuraType, 69, 46, "", "text", nil, nil, "TextOnlyAuraTypeButton")
        
        Icon_IconAuraTypeButton:SetPoint ("center", Icon_IconAuraType, "center")
        Icon_StatusbarAuraTypeButton:SetPoint ("center", Icon_StatusbarAuraType, "center")
        Icon_TextOnlyAuraTypeButton:SetPoint ("center", Icon_TextOnlyAuraType, "center")
        
        Icon_IconAuraTypeButton:SetBackdrop ({edgeFile = [[Interface\AddOns\Details\images\dotted]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
        Icon_IconAuraTypeButton:SetBackdropColor (unpack (AuraTypeSelectedColor))
        Icon_IconAuraTypeButton:SetBackdropBorderColor (unpack (AuraTypeBorderColor))
        
        Icon_StatusbarAuraTypeButton:SetBackdrop ({edgeFile = [[Interface\AddOns\Details\images\dotted]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
        Icon_StatusbarAuraTypeButton:SetBackdropColor (0, 0, 0, 0.05)
        Icon_StatusbarAuraTypeButton:SetBackdropBorderColor (unpack (AuraTypeBorderColor))
        
        Icon_TextOnlyAuraTypeButton:SetBackdrop ({edgeFile = [[Interface\AddOns\Details\images\dotted]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
        Icon_TextOnlyAuraTypeButton:SetBackdropColor (0, 0, 0, 0.05)
        Icon_TextOnlyAuraTypeButton:SetBackdropBorderColor (unpack (AuraTypeBorderColor))
        
        --trigger list
        --target
        local on_select_aura_trigger = function (_, _, aura_trigger)
            if (f.UpdateLabels) then
                f:UpdateLabels()
            end
        end
        
        local aura_on_icon = [[Interface\Buttons\UI-GroupLoot-DE-Down]]
        local aura_on_table = {
            {label = "Debuff on You", value = 1, icon = aura_on_icon, onclick = on_select_aura_trigger},
            {label = "Debuff on Target", value = 2, icon = aura_on_icon, onclick = on_select_aura_trigger},
            {label = "Debuff on Focus", value = 3, icon = aura_on_icon, onclick = on_select_aura_trigger},
            
            {label = "Buff on You", value = 11, icon = aura_on_icon, onclick = on_select_aura_trigger},
            {label = "Buff on Target", value = 12, icon = aura_on_icon, onclick = on_select_aura_trigger},
            {label = "Buff on Focus", value = 13, icon = aura_on_icon, onclick = on_select_aura_trigger},
            
            {label = "Spell Cast Started", value = 21, icon = aura_on_icon, onclick = on_select_aura_trigger},
            {label = "Spell Cast Successful", value = 22, icon = aura_on_icon, onclick = on_select_aura_trigger},
            
            {label = "DBM Time Bar", value = 31, icon = aura_on_icon, onclick = on_select_aura_trigger},
            {label = "BigWigs Time Bar", value = 32, icon = aura_on_icon, onclick = on_select_aura_trigger},
            
            {label = "Spell Interrupt", value = 41, icon = aura_on_icon, onclick = on_select_aura_trigger},
            {label = "Spell Dispell", value = 42, icon = aura_on_icon, onclick = on_select_aura_trigger},
        }
        local aura_on_options = function()
            return aura_on_table
        end
        local aura_on = fw:CreateDropDown (f, aura_on_options, 1, 150, 20, "AuraOnDropdown", "$parentAuraOnDropdown")
        local aura_on_label = fw:CreateLabel (f, "Trigger On: ", nil, nil, "GameFontNormal")
        aura_on:SetPoint ("left", aura_on_label, "right", 2, 0)
        aura_on:Hide()
        
        local triggerList = {
            {name = "Debuff on You", value = 1},
            {name = "Debuff on Target", value = 2}, --2
            {name = "Debuff on Focus", value = 3},
            {name = "Buff on You", value = 11}, --4
            {name = "Buff on Target", value = 12},
            {name = "Buff on Focus", value = 13},
            {name = "Spell Cast Started", value = 21}, --7
            {name = "Spell Cast Successful", value = 22},
            {name = "DBM Time Bar", value = 31},
            {name = "BigWigs Time Bar", value = 32},
            {name = "Spell Interrupt", value = 41},
            {name = "Spell Dispell", value = 42},
        }
        
        local SetTriggerState = function (triggerID)
            for i = 1, #triggerList do
                triggerList[i].checkBox:SetValue (false)
                if (triggerList[i].value == triggerID) then
                    triggerList[i].checkBox:SetValue (true)
                end
            end
        end
        
        f.SetTriggerState = SetTriggerState
        f.TriggerList = triggerList
        
        local OnChangeTriggerState = function (self, triggerID, state)
            SetTriggerState (triggerID)
            aura_on:SetValue (triggerID)
            
            if (f.UpdateLabels) then
                f:UpdateLabels()
            end
        end
        
        for i = 1, #triggerList do
            local checkBox = fw:CreateSwitch (f, OnChangeTriggerState, i == 1)
            checkBox:SetTemplate (fw:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
            checkBox:SetAsCheckBox()
            checkBox:SetFixedParameter (triggerList [i].value)
            
            checkBox:SetSize (20, 20)
            checkBox:SetPoint ("topleft", aura_on_label, "bottomleft", 0, 12 + (-i*20))
            local label = fw:CreateLabel (f, triggerList [i].name)
            label:SetPoint ("left", checkBox, "right", 2, 0)
            
            triggerList [i].checkBox = checkBox
        end
        

        
        
        --spellname
        local spellname_label = fw:CreateLabel (f, "Spell Name: ", nil, nil, "GameFontNormal")
        local spellname_textentry = fw:CreateTextEntry (f, _detalhes.empty_function, 150, 20, "SpellName", "$parentSpellName")
        spellname_textentry:SetTemplate (slider_template)
        spellname_textentry:SetPoint ("left", spellname_label, "right", 2, 0)
        f.spellname = spellname_textentry
        spellname_textentry.tooltip = "Spell/Debuff/Buff to be tracked."
        
        --spellid
        local auraid_label = fw:CreateLabel (f, "Spell Id: ", nil, nil, "GameFontNormal")
        local auraid_textentry = fw:CreateTextEntry (f, _detalhes.empty_function, 150, 20, "AuraSpellId", "$parentAuraSpellId")
        auraid_textentry:SetTemplate (slider_template)
        auraid_textentry:Disable()
        auraid_textentry:SetPoint ("left", auraid_label, "right", 2, 0)
        
        --use spellid
        local usespellid_label = fw:CreateLabel (f, "Use SpellId: ", nil, nil, "GameFontNormal")
        local aura_use_spellid = fw:CreateSwitch (f, function(_, _, state) if (state) then auraid_textentry:Enable() else auraid_textentry:Disable() end end, false, nil, nil, nil, nil, "UseSpellId")
        aura_use_spellid:SetTemplate (fw:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
        aura_use_spellid:SetAsCheckBox()			
        
        aura_use_spellid:SetPoint ("left", usespellid_label, "right", 2, 0)
        aura_use_spellid.tooltip = "Use the spell id instead of the spell name, for advanced users."
        
        --in combat only
        local incombat_label = fw:CreateLabel (f, "Only in Combat: ", nil, nil, "GameFontNormal")
        local aura_incombat = fw:CreateSwitch (f, function(_, _, state) end, true, nil, nil, nil, nil, "UseInCombat")
        aura_incombat:SetTemplate (fw:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
        aura_incombat:SetAsCheckBox()			
        aura_incombat:SetPoint ("left", incombat_label, "right", 2, 0)
        aura_incombat.tooltip = "Only active when in combat."

        --aura icon
        local icon_label = fw:CreateLabel (f, "Icon: ", nil, nil, "GameFontNormal")
        local icon_button_func = function (texture)
            f.IconButton.icon.texture = texture
        end
        local icon_pick_button = fw:NewButton (f, nil, "$parentIconButton", "IconButton", 20, 20, function() fw:IconPick (icon_button_func, true) end)
        local icon_button_icon = fw:NewImage (icon_pick_button, [[Interface\ICONS\TEMP]], 19, 19, "background", nil, "icon", "$parentIcon")
        icon_pick_button:InstallCustomTexture()
        
        icon_pick_button:SetPoint ("left", icon_label, "right", 2, 0)
        icon_button_icon:SetPoint ("left", icon_label, "right", 2, 0)
        
        f.icon = icon_button_icon
        
        --is cooldown
        local iscooldown_label = fw:CreateLabel (f, "Cooldown Animation: ", nil, nil, "GameFontNormal")
        local aura_iscooldown = fw:CreateSwitch (f, function(_, _, state) end, true, nil, nil, nil, nil, "IsCooldown")
        aura_iscooldown:SetTemplate (fw:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
        aura_iscooldown:SetAsCheckBox()			
        aura_iscooldown:SetPoint ("left", iscooldown_label, "right", 2, 0)
        aura_iscooldown.tooltip = "Only active when in combat."
        
        --stack
        local stack_slider = fw:NewSlider (f, f, "$parentStackSlider", "StackSlider", 150, 20, 0, 30, 1, 0, true)
        stack_slider.useDecimals = true
        stack_slider:SetTemplate (slider_template)
        local stack_label = fw:CreateLabel (f, "Trigger Stack Size: ", nil, nil, "GameFontNormal")
        stack_slider:SetPoint ("left", stack_label, "right", 2, 0)
        stack_slider.tooltip = "Minimum amount of stacks to trigger the aura."
        
        --sound effect
        local play_sound = function (self, fixedParam, file)
            if (type (file) == "table") then
                PlaySoundFile (file.sound_path, "Master")
            else
                PlaySoundFile (file, "Master")
            end
        end
        
        local sort = function (t1, t2)
            return t1.name < t2.name
        end
        local titlecase = function (first, rest)
            return first:upper()..rest:lower()
        end
        local iconsize = {14, 14}
        
        local game_sounds = {
        --8.2 broke file paths, removing them until a way of converting to soundIds is possible
            --[=[
            ["Horde Banner Down"] = [[Sound\event\EVENT_VashjirIntro_HordeBannerDown_01.ogg]],
            ["Mast Crack"] = [[Sound\event\EVENT_VashjirIntro_MastCrack_01.ogg]],
            ["Orc Attack "] = [[Sound\event\EVENT_VashjirIntro_OrcAttackVox_03.ogg]],
            ["Ship Hull Impact"] = [[Sound\event\EVENT_VashjirIntro_ShipHullImpact_03.ogg]],
            ["Run! 01"] = [[Sound\character\Scourge\ScourgeVocalFemale\UndeadFemaleFlee01.ogg]],
            ["Run! 02"] = [[Sound\creature\HoodWolf\HoodWolfTransformPlayer01.ogg]],
            ["Danger!"] = [[Sound\character\Scourge\ScourgeVocalMale\UndeadMaleIncoming01.ogg]],
            ["Wing Flap 01"] = [[Sound\creature\Illidan\IllidanWingFlap2.ogg]],
            ["Wing Flap 02"] = [[Sound\Universal\BirdFlap1.ogg]],
            ["Not Prepared"] = [[Sound\creature\Illidan\BLACK_Illidan_04.ogg]],
            ["Cannon Shot"] = [[Sound\DOODAD\AGS_BrassCannon_Custom0.ogg]],
            ["Click 01"] = [[Sound\DOODAD\HangingBones_BoneClank06.ogg]],
            ["Click 02"] = [[Sound\DOODAD\HangingBones_BoneClank02.ogg]],
            ["Click 03"] = [[Sound\DOODAD\HangingBones_BoneClank03.ogg]],
            ["Click 04"] = [[Sound\DOODAD\HangingBones_BoneClank09.ogg]],
            ["Click 05"] = [[Sound\DOODAD\FX_Emote_Chopping_Wood08.ogg]],
            ["Click 06"] = [[Sound\DOODAD\FX_Emote_Chopping_Wood04.ogg]],
            ["Click 07"] = [[Sound\DOODAD\FX_BoardTilesDice_02.OGG]],
            ["Click 08"] = [[Sound\Spells\IceCrown_Bug_Attack_08.ogg]],
            ["Click 09"] = [[Sound\Spells\Tradeskills\BlackSmithCraftingE.ogg]],
            ["Chest 01"] = [[Sound\DOODAD\G_BarrelOpen-Chest1.ogg]],
            ["Beat 01"] = [[Sound\DOODAD\GO_PA_Kungfugear_bag_Left08.OGG]],
            ["Beat 02"] = [[Sound\DOODAD\GO_PA_Kungfugear_bag_Left04.OGG]],
            ["Water Drop"] = [[Sound\DOODAD\Hellfire_DW_Pipe_Type4_01.ogg]],
            ["Frog"] = [[Sound\EMITTERS\Emitter_Dalaran_Petstore_Frog_01.ogg]],
            --]=]
        }
        
        local sound_options = function()
            local t = {{label = "No Sound", value = "", icon = [[Interface\Buttons\UI-GuildButton-MOTD-Disabled]], iconsize = iconsize}}
            
            local sounds = {}
            local already_added = {}
            
            for name, soundFile in pairs (game_sounds) do
                name = name:gsub ("(%a)([%w_']*)", titlecase)
                if (not already_added [name]) then
                    sounds [#sounds+1] = {name = name, file = soundFile, gamesound = true}
                    already_added [name] = true
                end
            end
            
            for name, soundFile in pairs (LibStub:GetLibrary("LibSharedMedia-3.0"):HashTable ("sound")) do
                name = name:gsub ("(%a)([%w_']*)", titlecase)
                if (not already_added [name]) then
                    sounds [#sounds+1] = {name = name, file = soundFile}
                    already_added [name] = true
                end
            end
            
            if (WeakAuras and WeakAuras.sound_types) then
                for soundFile, name in pairs (WeakAuras.sound_types) do
                    name = name:gsub ("(%a)([%w_']*)", titlecase)
                    if (not already_added [name]) then
                        sounds [#sounds+1] = {name = name, file = soundFile}
                    end
                end
            end
            
            table.sort (sounds, sort)
            
            for _, sound in ipairs (sounds) do
                if (sound.name:find ("D_")) then --> details sound
                    tinsert (t, {color = "orange", label = sound.name, value = sound.file, icon = [[Interface\Buttons\UI-GuildButton-MOTD-Up]], onclick = play_sound, iconsize = iconsize})
                elseif (sound.gamesound) then --> game sound
                    tinsert (t, {color = "yellow", label = sound.name, value = {sound_path = sound.file}, icon = [[Interface\Buttons\UI-GuildButton-MOTD-Up]], onclick = play_sound, iconsize = iconsize})
                else
                    tinsert (t, {label = sound.name, value = sound.file, icon = [[Interface\Buttons\UI-GuildButton-MOTD-Up]], onclick = play_sound, iconsize = iconsize})
                end
            end
            return t
        end
        local sound_effect = fw:CreateDropDown (f, sound_options, 1, 150, 20, "SoundEffectDropdown", "$parentSoundEffectDropdown")
        sound_effect:SetTemplate (slider_template)
        local sound_effect_label = fw:CreateLabel (f, "Play Sound: ", nil, nil, "GameFontNormal")
        sound_effect:SetPoint ("left", sound_effect_label, "right", 2, 0)
        sound_effect.tooltip = "Sound played when the aura triggers."
        
        --say something
        local say_something_label = fw:CreateLabel (f, "/Say on Trigger: ", nil, nil, "GameFontNormal")
        local say_something = fw:CreateTextEntry (f, _detalhes.empty_function, 150, 20, "SaySomething", "$parentSaySomething")
        say_something:SetTemplate (slider_template)
        say_something:SetPoint ("left", say_something_label, "right", 2, 0)
        say_something.tooltip = "Your character /say this phrase when the aura triggers."
        
        --aura text
        local aura_text_label = fw:CreateLabel (f, "Aura Text: ", nil, nil, "GameFontNormal")
        local aura_text = fw:CreateTextEntry (f, _detalhes.empty_function, 150, 20, "AuraText", "$parentAuraText")
        aura_text:SetTemplate (slider_template)
        aura_text:SetPoint ("left", aura_text_label, "right", 2, 0)
        aura_text.tooltip = "Text shown at aura's icon right side."
        
        --apply glow
        local useglow_label = fw:CreateLabel (f, "Glow Effect: ", nil, nil, "GameFontNormal")
        local useglow = fw:CreateSwitch (f, function(self, _, state) 
            if (state and self.glow_test) then  
                self.glow_test:Show()
                self.glow_test.animOut:Stop()
                self.glow_test.animIn:Play()
            elseif (self.glow_test) then
                self.glow_test.animIn:Stop()
                self.glow_test.animOut:Play()
            end 
        end, false, nil, nil, nil, nil, "UseGlow")
        
        useglow:SetTemplate (fw:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
        useglow:SetAsCheckBox()			
        
        useglow:SetPoint ("left", useglow_label, "right", 2, 0)
        useglow.tooltip = "Do not rename the aura on WeakAuras options panel or the glow effect may not work."
        
        useglow.glow_test = CreateFrame ("frame", "DetailsAuraTextGlowTest", useglow.widget, "ActionBarButtonSpellActivationAlert")
        useglow.glow_test:SetPoint ("topleft", useglow.widget, "topleft", -20, 2)
        useglow.glow_test:SetPoint ("bottomright", useglow.widget, "bottomright", 20, -2)
        useglow.glow_test:Hide()

        --encounter id
        local encounterid_label = fw:CreateLabel (f, "Encounter ID: ", nil, nil, "GameFontNormal")
        local encounterid = fw:CreateTextEntry (f, _detalhes.empty_function, 150, 20, "EncounterIdText", "$parentEncounterIdText")
        encounterid:SetTemplate (slider_template)
        encounterid:SetPoint ("left", encounterid_label, "right", 2, 0)
        encounterid.tooltip = "Only load this aura for this raid encounter."
        
        --size
        local icon_size_slider = fw:NewSlider (f, f, "$parentIconSizeSlider", "IconSizeSlider", 150, 20, 8, 256, 1, 64)
        local icon_size_label = fw:CreateLabel (f, "Size: ", nil, nil, "GameFontNormal")
        icon_size_slider:SetTemplate (slider_template)
        icon_size_slider:SetPoint ("left", icon_size_label, "right", 2, 0)
        icon_size_slider.tooltip = "Icon size, width and height."
        
        --aura addon
        local addon_options = function()
            local t = {}
            if (WeakAuras) then
                tinsert (t, {label = "Weak Auras 2", value = "WA", icon = [[Interface\AddOns\WeakAuras\Media\Textures\icon]]})
            end
            return t
        end
        local aura_addon = fw:CreateDropDown (f, addon_options, 1, 150, 20, "AuraAddonDropdown", "$parentAuraAddonDropdown")
        aura_addon:SetTemplate (slider_template)
        local aura_addon_label = fw:CreateLabel (f, "Addon: ", nil, nil, "GameFontNormal")
        aura_addon:SetPoint ("left", aura_addon_label, "right", 2, 0)
        
        --weakauras - group
        
        local folder_icon = [[Interface\AddOns\Details\images\icons]]
        local folder_texcoord = {435/512, 469/512, 189/512, 241/512}
        local folder_iconsize = {14, 14}

        local sort_func = function (t1, t2) return t1.label < t2.label end
        
        local weakauras_folder_options = function()
            local t = {}
            if (WeakAuras and WeakAurasSaved) then
                for display_name, aura_table in pairs (WeakAurasSaved.displays) do
                    if (aura_table.regionType == "dynamicgroup" or aura_table.regionType == "group") then
                        tinsert (t, {label = display_name, value = display_name, icon = folder_icon, texcoord = folder_texcoord, iconsize = folder_iconsize})
                    end
                end
            end
            table.sort (t, sort_func)
            tinsert (t, 1, {label = "No Group", value = false, icon = folder_icon, texcoord = folder_texcoord, iconcolor = {0.8, 0.2, 0.2}, iconsize = folder_iconsize})
            return t
        end
        
        local weakauras_folder_label = fw:CreateLabel (f, "WeakAuras Group: ", nil, nil, "GameFontNormal")
        local weakauras_folder = fw:CreateDropDown (f, weakauras_folder_options, 1, 150, 20, "WeakaurasFolderDropdown", "$parentWeakaurasFolder")
        weakauras_folder:SetTemplate (slider_template)
        weakauras_folder:SetPoint ("left", weakauras_folder_label, "right", 2, 0)
        
        --make new group
        local create_wa_group = function()
        
            local weakauras_newgroup_textentry = f.NewWeakaurasGroupTextEntry
        
            if (not WeakAurasSaved or not WeakAurasSaved.displays) then
                print ("nop, weakauras not found")
                return
            end
        
            local groupName = weakauras_newgroup_textentry.text
            
            if (string.len (groupName) == 0) then
                print ("nop, group name is too small")
                return
            end
            
            if (WeakAurasSaved.displays [groupName]) then
                print ("nop, group already exists")
                return
            end
            
            --make a copy of the prototype
            local newGroup = _detalhes.table.copy ({}, group_prototype)
            
            --set group settings
            newGroup.id = groupName
            newGroup.animate = false
            newGroup.grow = "DOWN"
            
            --add the gorup
            WeakAuras.Add (newGroup)
            
            --clear the text box
            weakauras_newgroup_textentry.text = ""
            weakauras_newgroup_textentry:ClearFocus()
            
            --select the new group in the dropdown
            weakauras_folder:Refresh()
            weakauras_folder:Select (groupName)
        end			
        
        local weakauras_newgroup_label = fw:CreateLabel (f, "New WeakAuras Group: ", nil, nil, "GameFontNormal")
        local weakauras_newgroup_textentry = fw:CreateTextEntry (f, create_wa_group, 150, 20, "NewWeakaurasGroupTextEntry", "$parentNewWeakaurasGroup")
        weakauras_newgroup_textentry:SetTemplate (slider_template)
        weakauras_newgroup_textentry:SetPoint ("left", weakauras_newgroup_label, "right", 2, 0)
        f.weakauras_newgroup = weakauras_newgroup_textentry
        weakauras_newgroup_textentry.tooltip = "Enter the name of the new group"
        
        local weakauras_newgroup_button = fw:CreateButton (f, create_wa_group, 106, 20, "Create Group")
        weakauras_newgroup_button:SetTemplate (slider_template)
        weakauras_newgroup_button:SetTemplate (_detalhes.gump:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
        weakauras_newgroup_button:SetWidth (100)
        weakauras_newgroup_button:SetPoint ("left", weakauras_newgroup_textentry, "right", 2, 0)
        
        
        --create
        local create_func = function()
            
            local name = f.AuraName.text
            local aura_type_value = f.AuraTypeDropdown.value
            local spellname = f.SpellName.text
            local use_spellId = f.UseSpellId.value
            local spellid = f.AuraSpellId.text
            local icon = f.IconButton.icon.texture
            local target = f.AuraOnDropdown.value
            local stacksize = f.StackSlider.value
            local sound = f.SoundEffectDropdown.value
            local chat = f.SaySomething.text
            local addon = f.AuraAddonDropdown.value
            local folder = f.WeakaurasFolderDropdown.value
            local iconsize = f.IconSizeSlider.value
            local incombat = f.UseInCombat.value
            local iscooldown = f.IsCooldown.value
            
            local icon_text = f.AuraText.text
            local icon_glow = f.UseGlow.value
            
            local eid = DetailsAuraPanel.EncounterIdText.text
            if (eid == "") then
                eid = nil
            end
            
            if (addon == "WA") then
                _detalhes:CreateWeakAura (aura_type_value, spellid, use_spellId, spellname, name, icon, target, stacksize, sound, chat, icon_text, icon_glow, eid, folder, iconsize, f.other_values, incombat, iscooldown)
            else
                _detalhes:Msg ("No Aura Addon selected. Addons currently supported: WeakAuras 2.")
            end
            
            f:Hide()
        end
        
        local create_button = fw:CreateButton (f, create_func, 106, 20, L["STRING_CREATEAURA"])
        create_button:SetTemplate (slider_template)
        create_button:SetTemplate (_detalhes.gump:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
        create_button:SetWidth (160)
        
        local cancel_button = fw:CreateButton (f, function() name_textentry:ClearFocus(); f:Hide() end, 106, 20, "Cancel")
        cancel_button:SetTemplate (_detalhes.gump:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
        cancel_button:SetWidth (160)
        
        
        create_button:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]], nil, nil, nil, {0.125, 0.875, 0.125, 0.875}, nil, 4, 2)
        cancel_button:SetIcon ([[Interface\Buttons\UI-GroupLoot-Pass-Down]], nil, nil, nil, {0.125, 0.875, 0.125, 0.875}, nil, 4, 2)
        
        local x_start = 20
        local x2_start = 420
        local y_start = 21

        --aura name and the type
        name_label:SetPoint ("topleft", f, "topleft", x_start, ((y_start*1) + (25)) * -1)
        aura_type_label:SetPoint ("topleft", f, "topleft", x_start, ((y_start*2) + (25)) * -1)
        
        --triggers
        aura_on_label:SetPoint ("topleft", f, "topleft", x_start, ((y_start*4) + (65)) * -1)
        stack_label:SetPoint ("topleft", f, "topleft", x_start, ((y_start*17) + (65)) * -1)
        encounterid_label:SetPoint ("topleft", f, "topleft", x_start, ((y_start*18) + (65)) * -1)
        
        --about the spell
        spellname_label:SetPoint ("topleft", f, "topleft", x_start, ((y_start*20) + (45)) * -1)
        usespellid_label:SetPoint ("topleft", f, "topleft", x_start, ((y_start*21) + (45)) * -1)
        auraid_label:SetPoint ("topleft", f, "topleft", x_start, ((y_start*22) + (45)) * -1)
        incombat_label:SetPoint ("topleft", f, "topleft", x_start, ((y_start*23) + (45)) * -1)

        --configuration
        icon_label:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*6) + (47)) * -1)
        sound_effect_label:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*7) + (47)) * -1)
        say_something_label:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*8) + (47)) * -1)
        aura_text_label:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*9) + (47)) * -1)
        useglow_label:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*10) + (47)) * -1)
        iscooldown_label:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*11) + (47)) * -1)
        icon_size_label:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*12) + (47)) * -1)
        
        aura_addon_label:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*17) + (60)) * -1)
        weakauras_folder_label:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*18) + (60)) * -1)
        weakauras_newgroup_label:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*19) + (60)) * -1)
        
        
        create_button:SetPoint ("topleft", f, "topleft", x2_start, ((y_start*21) + (60)) * -1)
        cancel_button:SetPoint ("left", create_button, "right", 20, 0)
        
        function f:UpdateLabels()
        
            local aura_type = f.AuraTypeDropdown.value
            local trigger = f.AuraOnDropdown.value
            
            f.StackSlider:Enable()
            f.StackSlider.tooltip = "Minimum amount of stacks to trigger the aura."
            f.StackSlider:SetValue (0)
            f.SpellName:Enable()
            f.UseSpellId:Enable()
            f.AuraSpellId:Enable()
            f.AuraName:Enable()
            f.IconSizeSlider:Enable()
            f.AuraTypeDropdown:Enable()
            f.SoundEffectDropdown:Enable()
            f.SaySomething:Enable()
            f.IconButton:Enable()
            f.AuraOnDropdown:Enable()
            f.AuraText:Enable()
            f.AuraText:SetText ("")
            aura_text_label.text = "Aura Text: "
            f.UseGlow:Enable()
            f.IsCooldown:Enable()
            
            if (aura_type == "icon") then
                aura_text_label:SetText ("Icon Text: ")
                icon_size_label:SetText ("Width/Height: ")
                f.IconSizeSlider:SetValue (64)
                
            elseif (aura_type == "text") then
                aura_text_label:SetText ("Text: ")
                icon_size_label:SetText ("Font Size: ")
                f.IconSizeSlider:SetValue (12)
                f.IsCooldown:Disable()
                
            elseif (aura_type == "aurabar") then
                aura_text_label:SetText ("Left Text: ")
                icon_size_label:SetText ("Bar Width: ")
                f.IconSizeSlider:SetValue (250)
                f.IsCooldown:Disable()
            end

            if (trigger >= 1 and trigger <= 19) then --buff and debuff
                stack_label:SetText ("Trigger Stack Size: ")
            
            elseif (trigger >= 20 and trigger <= 29) then --cast end cast start
                stack_label:SetText ("Cast Duration: ")
                f.StackSlider:SetValue (2)
            
            elseif (trigger >= 30 and trigger <= 39) then --boss mods
                stack_label:SetText ("Trigger Remaining Time:")
                f.StackSlider:SetValue (4)
                f.StackSlider.tooltip = "Will trigger when the bar remaining time reach this value."
                f.IconSizeSlider:SetValue (64)
                f.SpellName:Disable()
                f.UseSpellId:Disable()
                
            elseif (trigger == 41 or trigger == 42) then --interrupt or dispel
                f.StackSlider:Disable()
                f.SpellName:Disable()
                f.UseSpellId:Disable()
                DetailsAuraPanel.AuraTypeDropdown:Select (2, true)
                DetailsAuraPanel.OnSelectAuraType (nil, nil, 2, true)
                f.IsCooldown:Disable()
                
                f.SoundEffectDropdown:Disable()
                f.SaySomething:Disable()
                f.IconButton:Disable()
                f.UseGlow:Disable()
                icon_size_label:SetText ("Text Size: ")
                f.IconSizeSlider:SetValue (11)
                if (trigger == 41) then
                    f.AuraText:SetText ("=Not Interrupted!=")
                    aura_text_label.text = "Not Interrupted: "
                elseif (trigger == 42) then
                    f.AuraText:SetText (DetailsAuraPanel.name.text:gsub ("%(d!%)", "") .. "Dispells")
                    aura_text_label.text = "Title Text: "
                end
            end
            
            if (DetailsAuraPanel.other_values and DetailsAuraPanel.other_values.text) then
                DetailsAuraPanel.AuraText:SetText (DetailsAuraPanel.other_values.text)
            end
            
        end
        
    end
    
    DetailsAuraPanel.spellid = spellid
    DetailsAuraPanel.encounterid = encounterid
    DetailsAuraPanel.EncounterIdText.text = encounterid or ""
    
    DetailsAuraPanel.other_values = other_values
    
    DetailsAuraPanel.WeakaurasFolderDropdown:Refresh()
    if (encounterid) then
        DetailsAuraPanel.WeakaurasFolderDropdown:Select ("Details! Aura Group")
        DetailsAuraPanel.IconSizeSlider:SetValue (128)
    else
        DetailsAuraPanel.WeakaurasFolderDropdown:Select (1, true)
        DetailsAuraPanel.IconSizeSlider:SetValue (64)
    end
    
    if (DetailsAuraPanel.other_values.dbm_timer_id or DetailsAuraPanel.other_values.bw_timer_id) then
        DetailsAuraPanel.WeakaurasFolderDropdown:Select ("Details! Boss Mods Group")
    end
    
    if (DetailsAuraPanel.other_values.text_size) then
        DetailsAuraPanel.IconSizeSlider:SetValue (DetailsAuraPanel.other_values.text_size)
    end
    
    spellname = spellname or ""
    
    DetailsAuraPanel.name.text = spellname .. " (d!)"
    DetailsAuraPanel.spellname.text = spellname
    DetailsAuraPanel.AuraSpellId.text = tostring (spellid)
    DetailsAuraPanel.icon.texture = spellicon
    
    DetailsAuraPanel.UseGlow.glow_test.animIn:Stop()
    DetailsAuraPanel.UseGlow.glow_test.animOut:Play()
    DetailsAuraPanel.UseGlow:SetValue (false)
    
    DetailsAuraPanel.StackSlider:SetValue (0)
    DetailsAuraPanel.SoundEffectDropdown:Select (1, true)
    DetailsAuraPanel.AuraText:SetText (DetailsAuraPanel.other_values.text or "")
    DetailsAuraPanel.SaySomething:SetText ("")
    
    if (triggertype and type (triggertype) == "number") then
        DetailsAuraPanel.AuraOnDropdown:Select (triggertype, true)
        DetailsAuraPanel.SetTriggerState (DetailsAuraPanel.TriggerList [triggertype].value) --passed by index not by the trigger ID
    else
        DetailsAuraPanel.AuraOnDropdown:Select (1, true)
        DetailsAuraPanel.SetTriggerState (1)
    end
    
    if (auratype and type (auratype) == "number") then
        DetailsAuraPanel.AuraTypeDropdown:Select (auratype, true)
        DetailsAuraPanel.OnSelectAuraType (nil, nil, auratype)
    else
        DetailsAuraPanel.AuraTypeDropdown:Select (1, true)
        DetailsAuraPanel.OnSelectAuraType (nil, nil, "icon")
    end
    
    DetailsAuraPanel:UpdateLabels()
    
    DetailsAuraPanel:Show()
    DetailsPluginContainerWindow.OpenPlugin (DetailsAuraPanel)
    
end
