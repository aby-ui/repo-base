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
	
	--templates
	
	local UnitGroupRolesAssigned = DetailsFramework.UnitGroupRolesAssigned
	
	_detalhes:GetFramework():InstallTemplate ("button", "DETAILS_FORGE_TEXTENTRY_TEMPLATE", {
		backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true}, --edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, 
		backdropcolor = {0, 0, 0, .1},
	})
	
	local CONST_BUTTON_TEMPLATE = _detalhes:GetFramework():InstallTemplate ("button", "DETAILS_FORGE_BUTTON_TEMPLATE", {
		width = 140,
	},
	"DETAILS_PLUGIN_BUTTON_TEMPLATE")
	
	local CONST_BUTTONSELECTED_TEMPLATE = _detalhes:GetFramework():InstallTemplate ("button", "DETAILS_FORGE_BUTTONSELECTED_TEMPLATE", {
		width = 140,
	}, 
	"DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE")
	
	--weak auras	
	
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
		["controlledChildren"] = {},
		["animate"] = true,
		["xOffset"] = 0,
		["border"] = "None",
		["yOffset"] = 370,
		["anchorPoint"] = "CENTER",
		["untrigger"] = {},
		["sort"] = "none",
		["actions"] = {
			["start"] = {},
			["finish"] = {},
			["init"] = {},
		},
		["space"] = 2,
		["background"] = "None",
		["expanded"] = true,
		["constantFactor"] = "RADIUS",
		["selfPoint"] = "TOP",
		["borderOffset"] = 16,
		["trigger"] = {
			["type"] = "aura",
			["spellIds"] = {
			},
			["names"] = {},
			["debuffType"] = "HELPFUL",
			["unit"] = "player",
		},
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
		["id"] = "Details! Boss Mods Group",
		["backgroundInset"] = 0,
		["frameStrata"] = 1,
		["width"] = 359.096801757813,
		["rotation"] = 0,
		["radius"] = 200,
		["numTriggers"] = 1,
		["stagger"] = 0,
		["height"] = 121.503601074219,
		["align"] = "CENTER",
		["load"] = {
			["difficulty"] = {
				["multi"] = {
				},
			},
			["role"] = {
				["multi"] = {
				},
			},
			["use_class"] = false,
			["talent"] = {
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
			["class"] = {
			},
			["size"] = {
				["multi"] = {
				},
			},
		},
		["regionType"] = "dynamicgroup",
	}
	
	local group_prototype = {
		["xOffset"] = -678.999450683594,
		["yOffset"] = 212.765991210938,
		["id"] = "Details! Aura Group",
		["grow"] = "RIGHT",
		["controlledChildren"] = {},
		["animate"] = true,
		["border"] = "None",
		["anchorPoint"] = "CENTER",
		["regionType"] = "dynamicgroup",
		["sort"] = "none",
		["actions"] = {},
		["space"] = 0,
		["background"] = "None",
		["expanded"] = true,
		["constantFactor"] = "RADIUS",
		["trigger"] = {
			["type"] = "aura",
			["spellIds"] = {},
			["unit"] = "player",
			["debuffType"] = "HELPFUL",
			["names"] = {},
		},
		["borderOffset"] = 16,
		
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
		["align"] = "CENTER",
		["rotation"] = 0,
		["frameStrata"] = 1,
		["width"] = 199.999969482422,
		["height"] = 20,
		["stagger"] = 0,
		["radius"] = 200,
		["numTriggers"] = 1,
		["backgroundInset"] = 0,
		["selfPoint"] = "LEFT",
		["load"] = {
			["use_combat"] = true,
			["race"] = {
				["multi"] = {},
			},
			["talent"] = {
				["multi"] = {},
			},
			["role"] = {
				["multi"] = {},
			},
			["spec"] = {
				["multi"] = {},
			},
			["class"] = {
				["multi"] = {},
			},
			["size"] = {
				["multi"] = {},
			},
		},
		["untrigger"] = {},
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
		["yOffset"] = 202.07,
		["xOffset"] = -296.82,
		["fontSize"] = 14,
		["displayStacks"] = "%s",
		["parent"] = "Details! Aura Group",
		["color"] = {1, 1, 1, 1},
		["stacksPoint"] = "BOTTOMRIGHT",
		["regionType"] = "icon",
		["untrigger"] = {},
		["anchorPoint"] = "CENTER",
		["icon"] = true,
		["numTriggers"] = 1,
		["customTextUpdate"] = "update",
		["id"] = "UNNAMED",
		["actions"] = {},
		["fontFlags"] = "OUTLINE",
		["stacksContainment"] = "INSIDE",
		["zoom"] = 0,
		["auto"] = false,
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
		["desaturate"] = false,
		["frameStrata"] = 1,
		["stickyDuration"] = false,
		["width"] = 192,
		["font"] = "Friz Quadrata TT",
		["inverse"] = false,
		["selfPoint"] = "CENTER",
		["height"] = 192,
		["displayIcon"] = "Interface\\Icons\\Spell_Holiday_ToW_SpiceCloud",
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
		["textColor"] = {1, 1, 1, 1},
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
			["spellId"] = "0",
			["unit"] = "",
			["spellIds"] = {},
			["debuffType"] = "HARMFUL",
			["names"] = {},
		},
	}
	local buff_prototype = {
		["cooldown"] = false,
		["trigger"] = {
			["spellId"] = "0",
			["unit"] = "",
			["spellIds"] = {},
			["debuffType"] = "HELPFUL",
			["names"] = {},
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
		if (not WeakAurasSaved.displays ["Details! Aura Group"]) then
			local group = _detalhes.table.copy ({}, group_prototype)
			WeakAuras.Add (group)
		end
		
		if (not WeakAurasSaved.displays ["Details! Boss Mods Group"]) then
			local group = _detalhes.table.copy ({}, group_prototype_boss_mods)
			WeakAuras.Add (group)
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
					add.trigger.spellIds[1] = spellid
					add.trigger.names [1] = spellname
					add.trigger.unit = "player"
					_detalhes.table.overwrite (new_aura, add)
					
				elseif (target == 2) then --Debuff on Target
					local add = _detalhes.table.copy ({}, debuff_prototype)
					add.trigger.spellId = tostring (spellid)
					add.trigger.spellIds[1] = spellid
					add.trigger.names[1] = spellname
					add.trigger.unit = "target"
					
					--set as own only to avoid being active by other players
					add.trigger.ownOnly = true
					
					_detalhes.table.overwrite (new_aura, add)

				elseif (target == 3) then --Debuff on Focus
					local add = _detalhes.table.copy ({}, debuff_prototype)
					add.trigger.spellId = tostring (spellid)
					add.trigger.spellIds[1] = spellid
					add.trigger.names[1] = spellname
					add.trigger.unit = "focus"
					_detalhes.table.overwrite (new_aura, add)
					
				elseif (target == 11) then --Buff on Player
					local add = _detalhes.table.copy ({}, buff_prototype)
					add.trigger.spellId = tostring (spellid)
					add.trigger.spellIds[1] = spellid
					add.trigger.names[1] = spellname
					add.trigger.unit = "player"
					_detalhes.table.overwrite (new_aura, add)
					
				elseif (target == 12) then --Buff on Target
					local add = _detalhes.table.copy ({}, buff_prototype)
					add.trigger.spellId = tostring (spellid)
					add.trigger.spellIds[1] = spellid
					add.trigger.names[1] = spellname
					add.trigger.unit = "target"
					_detalhes.table.overwrite (new_aura, add)
					
				elseif (target == 13) then --Buff on Focus
					local add = _detalhes.table.copy ({}, buff_prototype)
					add.trigger.spellId = tostring (spellid)
					add.trigger.spellIds[1] = spellid
					add.trigger.names[1] = spellname
					add.trigger.unit = "focus"
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
					new_aura.load.use_combat = true
				else
					new_aura.load.use_combat = nil
				end
			else
				new_aura.trigger.spellId = tostring (spellid)
				new_aura.trigger.name = spellname
				tinsert (new_aura.trigger.spellIds, spellid)
			end
			
			--> if is a regular auras without using spells ids
			if (not use_spellid) then
				new_aura.trigger.use_spellId = false
				new_aura.trigger.fullscan = false
				new_aura.trigger.spellId = nil
				--new_aura.trigger.spellIds = {}
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
		local DetailsAuraPanel = CreateFrame ("frame", "DetailsAuraPanel", UIParent)
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

			local f = DetailsAuraPanel or CreateFrame ("frame", "DetailsAuraPanel", UIParent)
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
			f.TitleBar = CreateFrame ("frame", "$parentTitleBar", f)
			f.TitleBar:SetPoint ("topleft", f, "topleft", 2, -3)
			f.TitleBar:SetPoint ("topright", f, "topright", -2, -3)
			f.TitleBar:SetHeight (20)
			f.TitleBar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
			f.TitleBar:SetBackdropColor (.2, .2, .2, 1)
			f.TitleBar:SetBackdropBorderColor (0, 0, 0, 1)
			
			--close button
			f.Close = CreateFrame ("button", "$parentCloseButton", f)
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
	
	------------------------------------------------------------------------------------------------------------------
	
	--> get the total of damage and healing of this phase
	function _detalhes:OnCombatPhaseChanged()
	
		local current_combat = _detalhes:GetCurrentCombat()
		local current_phase = current_combat.PhaseData [#current_combat.PhaseData][1]
		
		local phase_damage_container = current_combat.PhaseData.damage [current_phase]
		local phase_healing_container = current_combat.PhaseData.heal [current_phase]
		
		local phase_damage_section = current_combat.PhaseData.damage_section
		local phase_healing_section = current_combat.PhaseData.heal_section
		
		if (not phase_damage_container) then
			phase_damage_container = {}
			current_combat.PhaseData.damage [current_phase] = phase_damage_container
		end
		if (not phase_healing_container) then
			phase_healing_container = {}
			current_combat.PhaseData.heal [current_phase] = phase_healing_container
		end
		
		for index, damage_actor in ipairs (_detalhes.cache_damage_group) do
			local phase_damage = damage_actor.total - (phase_damage_section [damage_actor.nome] or 0)
			phase_damage_section [damage_actor.nome] = damage_actor.total
			phase_damage_container [damage_actor.nome] = (phase_damage_container [damage_actor.nome] or 0) + phase_damage
		end
		
		for index, healing_actor in ipairs (_detalhes.cache_healing_group) do
			local phase_heal = healing_actor.total - (phase_healing_section [healing_actor.nome] or 0)
			phase_healing_section [healing_actor.nome] = healing_actor.total
			phase_healing_container [healing_actor.nome] = (phase_healing_container [healing_actor.nome] or 0) + phase_heal
		end
		
	end
	
	function _detalhes:BossModsLink()
		if (_G.DBM) then
			local dbm_callback_phase = function (event, msg, ...)
			
				local mod = _detalhes.encounter_table.DBM_Mod
				
				if (not mod) then
					local id = _detalhes:GetEncounterIdFromBossIndex (_detalhes.encounter_table.mapid, _detalhes.encounter_table.id)
					if (id) then
						for index, tmod in ipairs (DBM.Mods) do 
							if (tmod.id == id) then
								_detalhes.encounter_table.DBM_Mod = tmod
								mod = tmod
							end
						end
					end
				end
				
				local phase = mod and mod.vb and mod.vb.phase
				if (phase and _detalhes.encounter_table.phase ~= phase) then
					--_detalhes:Msg ("Current phase:", phase)
					
					_detalhes:OnCombatPhaseChanged()
					
					_detalhes.encounter_table.phase = phase
					
					local cur_combat = _detalhes:GetCurrentCombat()
					local time = cur_combat:GetCombatTime()
					if (time > 5) then
						tinsert (cur_combat.PhaseData, {phase, time})
					end
					
					_detalhes:SendEvent ("COMBAT_ENCOUNTER_PHASE_CHANGED", nil, phase)
				end
			end
			
			local dbm_callback_pull = function (event, mod, delay, synced, startHp)
				_detalhes.encounter_table.DBM_Mod = mod
				_detalhes.encounter_table.DBM_ModTime = time()
			end
			
			DBM:RegisterCallback ("DBM_Announce", dbm_callback_phase)
			DBM:RegisterCallback ("pull", dbm_callback_pull)
		end
		
		if (BigWigsLoader and not _G.DBM) then
			function _detalhes:BigWigs_Message (event, module, key, text, ...)
				
				if (key == "stages") then
					local phase = text:gsub (".*%s", "")
					phase = tonumber (phase)
					
					if (phase and type (phase) == "number" and _detalhes.encounter_table.phase ~= phase) then
						_detalhes:OnCombatPhaseChanged()
						
						_detalhes.encounter_table.phase = phase
						
						local cur_combat = _detalhes:GetCurrentCombat()
						local time = cur_combat:GetCombatTime()
						if (time > 5) then
							tinsert (cur_combat.PhaseData, {phase, time})
						end
						
						_detalhes:SendEvent ("COMBAT_ENCOUNTER_PHASE_CHANGED", nil, phase)
					end
					
				end
			end

			if (BigWigsLoader.RegisterMessage) then
				BigWigsLoader.RegisterMessage (_detalhes, "BigWigs_Message")
			end
		end
		
		
		_detalhes:CreateCallbackListeners()
	end	
	
	--removido do plugin Encounter Details
	function _detalhes:CreateCallbackListeners()
	
		_detalhes.DBM_timers = {}
		
		local current_encounter = false
		local current_table_dbm = {}
		local current_table_bigwigs = {}
	
		local event_frame = CreateFrame ("frame", nil, UIParent)
		event_frame:SetScript ("OnEvent", function (self, event, ...)
			if (event == "ENCOUNTER_START") then
				local encounterID, encounterName, difficultyID, raidSize = select (1, ...)
				current_encounter = encounterID
				
			elseif (event == "ENCOUNTER_END" or event == "PLAYER_REGEN_ENABLED") then
				if (current_encounter) then
					if (_G.DBM) then
						local db = _detalhes.boss_mods_timers
						for spell, timer_table in pairs (current_table_dbm) do
							if (not db.encounter_timers_dbm [timer_table[1]]) then
								timer_table.id = current_encounter
								db.encounter_timers_dbm [timer_table[1]] = timer_table
							end
						end
					end
					if (BigWigs) then
						local db = _detalhes.boss_mods_timers
						for timer_id, timer_table in pairs (current_table_bigwigs) do
							if (not db.encounter_timers_bw [timer_id]) then
								timer_table.id = current_encounter
								db.encounter_timers_bw [timer_id] = timer_table
							end
						end
					end
				end	
				
				current_encounter = false
				wipe (current_table_dbm)
				wipe (current_table_bigwigs)
			end
		end)
		event_frame:RegisterEvent ("ENCOUNTER_START")
		event_frame:RegisterEvent ("ENCOUNTER_END")
		event_frame:RegisterEvent ("PLAYER_REGEN_ENABLED")

		if (_G.DBM) then
			local dbm_timer_callback = function (bar_type, id, msg, timer, icon, bartype, spellId, colorId, modid)
				local spell = tostring (spellId)
				if (spell and not current_table_dbm [spell]) then
					current_table_dbm [spell] = {spell, id, msg, timer, icon, bartype, spellId, colorId, modid}
				end
			end
			DBM:RegisterCallback ("DBM_TimerStart", dbm_timer_callback)
		end
		function _detalhes:RegisterBigWigsCallBack()
			if (BigWigsLoader) then
				function _detalhes:BigWigs_StartBar (event, module, spellid, bar_text, time, icon, ...)
					spellid = tostring (spellid)
					if (not current_table_bigwigs [spellid]) then
						current_table_bigwigs [spellid] = {(type (module) == "string" and module) or (module and module.moduleName) or "", spellid or "", bar_text or "", time or 0, icon or ""}
					end
				end
				if (BigWigsLoader.RegisterMessage) then
					BigWigsLoader.RegisterMessage (_detalhes, "BigWigs_StartBar")
				end
			end
		end
		_detalhes:ScheduleTimer ("RegisterBigWigsCallBack", 5)
	end
	
	
	local SplitLoadFrame = CreateFrame ("frame")
	local MiscContainerNames = {
		"dispell_spells",
		"cooldowns_defensive_spells",
		"debuff_uptime_spells",
		"buff_uptime_spells",
		"interrupt_spells",
		"cc_done_spells",
		"cc_break_spells",
		"ress_spells",
	}
	local SplitLoadFunc = function (self, deltaTime)
		--which container it will iterate on this tick
		local container = _detalhes.tabela_vigente and _detalhes.tabela_vigente [SplitLoadFrame.NextActorContainer] and _detalhes.tabela_vigente [SplitLoadFrame.NextActorContainer]._ActorTable

		if (not container) then
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) finished index spells.")
			end
			SplitLoadFrame:SetScript ("OnUpdate", nil)
			return
		end
		
		local inInstance = IsInInstance()
		local isEncounter = _detalhes.tabela_vigente and _detalhes.tabela_vigente.is_boss
		local encounterID = isEncounter and isEncounter.id
		
		--get the actor
		local actorToIndex = container [SplitLoadFrame.NextActorIndex]
		
		--no actor? go to the next container
		if (not actorToIndex) then
			SplitLoadFrame.NextActorIndex = 1
			SplitLoadFrame.NextActorContainer = SplitLoadFrame.NextActorContainer + 1
			
			--finished all the 4 container? kill the process
			if (SplitLoadFrame.NextActorContainer == 5) then
				SplitLoadFrame:SetScript ("OnUpdate", nil)
				if (_detalhes.debug) then
					_detalhes:Msg ("(debug) finished index spells.")
				end
				return
			end
		else
			--++
			SplitLoadFrame.NextActorIndex = SplitLoadFrame.NextActorIndex + 1
			
			--get the class name or the actor name in case the actor isn't a player
			local source
			if (inInstance) then
				source = RAID_CLASS_COLORS [actorToIndex.classe] and _detalhes.classstring_to_classid [actorToIndex.classe] or actorToIndex.nome
			else
				source = RAID_CLASS_COLORS [actorToIndex.classe] and _detalhes.classstring_to_classid [actorToIndex.classe]
			end
			
			--if found a valid actor
			if (source) then
				--if is damage, heal or energy
				if (SplitLoadFrame.NextActorContainer == 1 or SplitLoadFrame.NextActorContainer == 2 or SplitLoadFrame.NextActorContainer == 3) then
					--get the spell list in the spells container
					local spellList = actorToIndex.spells and actorToIndex.spells._ActorTable
					if (spellList) then
					
						local SpellPool = _detalhes.spell_pool
						local EncounterSpellPool = _detalhes.encounter_spell_pool
						
						for spellID, _ in pairs (spellList) do
							if (not SpellPool [spellID]) then
								SpellPool [spellID] = source
							end
							if (encounterID and not EncounterSpellPool [spellID]) then
								if (actorToIndex:IsEnemy()) then
									EncounterSpellPool [spellID] = {encounterID, source}
								end
							end
						end
					end
				
				--if is a misc container
				elseif (SplitLoadFrame.NextActorContainer == 4) then
					for _, containerName in ipairs (MiscContainerNames) do 
						--check if the actor have this container
						if (actorToIndex [containerName]) then
							local spellList = actorToIndex [containerName]._ActorTable
							if (spellList) then
							
								local SpellPool = _detalhes.spell_pool
								local EncounterSpellPool = _detalhes.encounter_spell_pool
								
								for spellID, _ in pairs (spellList) do
									if (not SpellPool [spellID]) then
										SpellPool [spellID] = source
									end
									if (encounterID and not EncounterSpellPool [spellID]) then
										if (actorToIndex:IsEnemy()) then
											EncounterSpellPool [spellID] = {encounterID, source}
										end
									end
								end
							end
						end
					end
					
					--spells the actor casted
					if (actorToIndex.spell_cast) then
						local SpellPool = _detalhes.spell_pool
						local EncounterSpellPool = _detalhes.encounter_spell_pool
						
						for spellID, _ in pairs (actorToIndex.spell_cast) do
							if (not SpellPool [spellID]) then
								SpellPool [spellID] = source
							end
							if (encounterID and not EncounterSpellPool [spellID]) then
								if (actorToIndex:IsEnemy()) then
									EncounterSpellPool [spellID] = {encounterID, source}
								end
							end
						end
					end
				end
			end
		end
	end

	function _detalhes.StoreSpells()
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) started to index spells.")
		end
		SplitLoadFrame:SetScript ("OnUpdate", SplitLoadFunc)
		SplitLoadFrame.NextActorContainer = 1
		SplitLoadFrame.NextActorIndex = 1
	end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details auras

	local aura_prototype = {
		name = "",
		type = "DEBUFF",
		target = "player",
		boss = "0",
		icon = "",
		stack = 0,
		sound = "",
		sound_channel = "",
		chat = "",
		chat_where = "SAY",
		chat_extra = "",
	}
	
	function _detalhes:CreateDetailsAura (name, auratype, target, boss, icon, stack, sound, chat)
	
		local aura_container = _detalhes.details_auras
		
		--already exists
		if (aura_container [name]) then
			_detalhes:Msg ("Aura name already exists.")
			return
		end
		
		--create the new aura
		local new_aura = _detalhes.table.copy ({}, aura_prototype)
		new_aura.type = auratype or new_aura.type
		new_aura.target = auratype or new_aura.target
		new_aura.boss = boss or new_aura.boss
		new_aura.icon = icon or new_aura.icon
		new_aura.stack = math.max (stack or 0, new_aura.stack)
		new_aura.sound = sound or new_aura.sound
		new_aura.chat = chat or new_aura.chat
		
		_detalhes.details_auras [name] = new_aura
		
		return new_aura
	end
	
	function _detalhes:CreateAuraListener()
	
		local listener = _detalhes:CreateEventListener()
		
		function listener:on_enter_combat (event, combat, encounterId)
			
		end
		
		function listener:on_leave_combat (event, combat)
			
		end
		
		listener:RegisterEvent ("COMBAT_PLAYER_ENTER", "on_enter_combat")
		listener:RegisterEvent ("COMBAT_PLAYER_LEAVE", "on_leave_combat")
	
	end
	
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> forge

	function _detalhes:InitializeForge()
		local DetailsForgePanel = _detalhes.gump:CreateSimplePanel (UIParent, 960, 600, "Details! " .. L["STRING_SPELLLIST"], "DetailsForgePanel")
		DetailsForgePanel.Frame = DetailsForgePanel
		DetailsForgePanel.__name = L["STRING_SPELLLIST"]
		DetailsForgePanel.real_name = "DETAILS_FORGE"
		DetailsForgePanel.__icon = [[Interface\MINIMAP\Vehicle-HammerGold-3]]
		DetailsPluginContainerWindow.EmbedPlugin (DetailsForgePanel, DetailsForgePanel, true)
		
		function DetailsForgePanel.RefreshWindow()
			_detalhes:OpenForge()
		end
	end
	
	function _detalhes:OpenForge()
		
		if (not DetailsForgePanel or not DetailsForgePanel.Initialized) then
			
			local fw = _detalhes:GetFramework()
			local lower = string.lower
			
			DetailsForgePanel.Initialized = true
			
			--main frame
			local f = DetailsForgePanel or _detalhes.gump:CreateSimplePanel (UIParent, 960, 600, "Details! " .. L["STRING_SPELLLIST"], "DetailsForgePanel")
			f:SetPoint ("center", UIParent, "center")
			f:SetFrameStrata ("HIGH")
			f:SetToplevel (true)
			f:SetMovable (true)
			f.Title:SetTextColor (1, .8, .2)
			
			local have_plugins_enabled
			
			for id, instanceTable in pairs (_detalhes.EncounterInformation) do
				if (_detalhes.InstancesToStoreData [id]) then
					have_plugins_enabled = true
					break
				end
			end
			
			if (not have_plugins_enabled and false) then
				local nopluginLabel = f:CreateFontString (nil, "overlay", "GameFontNormal")
				local nopluginIcon = f:CreateTexture (nil, "overlay")
				nopluginIcon:SetPoint ("bottomleft", f, "bottomleft", 10, 10)
				nopluginIcon:SetSize (16, 16)
				nopluginIcon:SetTexture ([[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]])
				nopluginLabel:SetPoint ("left", nopluginIcon, "right", 5, 0)
				nopluginLabel:SetText (L["STRING_FORGE_ENABLEPLUGINS"])
			end
			
			if (not _detalhes:GetTutorialCVar ("FORGE_TUTORIAL")) then
				local tutorialFrame = CreateFrame ("frame", "$parentTutorialFrame", f)
				tutorialFrame:SetPoint ("center", f, "center")
				tutorialFrame:SetFrameStrata ("DIALOG")
				tutorialFrame:SetSize (400, 300)
				tutorialFrame:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
				insets = {left = 0, right = 0, top = 0, bottom = 0}, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize=1})
				tutorialFrame:SetBackdropColor (0, 0, 0, 1)
				
				tutorialFrame.Title = _detalhes.gump:CreateLabel (tutorialFrame, L["STRING_FORGE_TUTORIAL_TITLE"], 12, "orange")
				tutorialFrame.Desc = _detalhes.gump:CreateLabel (tutorialFrame, L["STRING_FORGE_TUTORIAL_DESC"], 12)
				tutorialFrame.Desc.width = 370
				tutorialFrame.Example = _detalhes.gump:CreateLabel (tutorialFrame, L["STRING_FORGE_TUTORIAL_VIDEO"], 12)
				
				tutorialFrame.Title:SetPoint ("top", tutorialFrame, "top", 0, -5)
				tutorialFrame.Desc:SetPoint ("topleft", tutorialFrame, "topleft", 10, -45)
				tutorialFrame.Example:SetPoint ("topleft", tutorialFrame, "topleft", 10, -110)
				
				local editBox = _detalhes.gump:CreateTextEntry (tutorialFrame, function()end, 375, 20, nil, nil, nil, entry_template, label_template)
				editBox:SetPoint ("topleft", tutorialFrame.Example, "bottomleft", 0, -10) 
				editBox:SetText ([[https://www.youtube.com/watch?v=om0k1Yj2pEw]])
				editBox:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
				
				local closeButton = _detalhes.gump:CreateButton (tutorialFrame, function() _detalhes:SetTutorialCVar ("FORGE_TUTORIAL", true); tutorialFrame:Hide() end, 80, 20, L["STRING_OPTIONS_CHART_CLOSE"])
				closeButton:SetPoint ("bottom", tutorialFrame, "bottom", 0, 10)
				closeButton:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
			end
			
			--modules
			local all_modules = {}
			local spell_already_added = {}
			
			f:SetScript ("OnHide", function()
				for _, module in ipairs (all_modules) do
					if (module.data) then
						wipe (module.data)
					end
				end
				wipe (spell_already_added)
			end)
			
			f.bg1 = f:CreateTexture (nil, "background")
			f.bg1:SetTexture ([[Interface\AddOns\Details\images\background]], true)
			f.bg1:SetAlpha (0.7)
			f.bg1:SetVertexColor (0.27, 0.27, 0.27)
			f.bg1:SetVertTile (true)
			f.bg1:SetHorizTile (true)
			f.bg1:SetSize (790, 454)
			f.bg1:SetAllPoints()
			
			f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			f:SetBackdropColor (.5, .5, .5, .5)
			f:SetBackdropBorderColor (0, 0, 0, 1)
			
			--[=[
			--scroll gradient
			local blackdiv = f:CreateTexture (nil, "artwork")
			blackdiv:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
			blackdiv:SetVertexColor (0, 0, 0)
			blackdiv:SetAlpha (1)
			blackdiv:SetPoint ("topleft", f, "topleft", 170, -100)
			blackdiv:SetHeight (461)
			blackdiv:SetWidth (200)
			
			--big gradient
			local blackdiv = f:CreateTexture (nil, "artwork")
			blackdiv:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
			blackdiv:SetVertexColor (0, 0, 0)
			blackdiv:SetAlpha (0.7)
			blackdiv:SetPoint ("topleft", f, "topleft", 0, 0)
			blackdiv:SetPoint ("bottomleft", f, "bottomleft", 0, 0)
			blackdiv:SetWidth (200)
			--]=]
			
			local no_func = function()end
			local nothing_to_show = {}
			local current_module
			local buttons = {}
			
			function f:InstallModule (module)
				if (module and type (module) == "table") then
					tinsert (all_modules, module)
				end
			end
			
			local all_players_module = {
				name = L["STRING_FORGE_BUTTON_PLAYERS"],
				desc = L["STRING_FORGE_BUTTON_PLAYERS_DESC"],
				filters_widgets = function()
					if (not DetailsForgeAllPlayersFilterPanel) then
						local w = CreateFrame ("frame", "DetailsForgeAllPlayersFilterPanel", f)
						w:SetSize (600, 20)
						w:SetPoint ("topleft", f, "topleft", 164, -40)
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_PLAYERNAME"] .. ": ")
						label:SetPoint ("left", w, "left", 5, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllPlayersNameFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
					end
					return DetailsForgeAllPlayersFilterPanel
				end,
				search = function()
					local t = {}
					local filter = DetailsForgeAllPlayersNameFilter:GetText()
					for _, actor in ipairs (_detalhes:GetCombat("current"):GetActorList (DETAILS_ATTRIBUTE_DAMAGE)) do
						if (actor:IsGroupPlayer()) then
							if (filter ~= "") then
								filter = lower (filter)
								local actor_name = lower (actor:name())
								if (actor_name:find (filter)) then
									t [#t+1] = actor
								end
							else
								t [#t+1] = actor
							end
						end
					end
					return t
				end,
				header = {
					{name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
					{name = L["STRING_FORGE_HEADER_NAME"], width = 150, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_CLASS"], width = 100, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_GUID"], width = 230, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_FLAG"], width = 100, type = "entry", func = no_func},
				},
				fill_panel = false,
				fill_gettotal = function (self) return #self.module.data end,
				fill_fillrows = function (index, self) 
					local data = self.module.data [index]
					if (data) then
						return {
							index,
							data:name() or "",
							data:class() or "",
							data.serial or "",
							"0x" .. _detalhes:hex (data.flag_original)
						}
					else
						return nothing_to_show
					end
				end,
				fill_name = "DetailsForgeAllPlayersFillPanel",
			}
			
			-----------------------------------------------
			local all_pets_module = {
				name = L["STRING_FORGE_BUTTON_PETS"],
				desc = L["STRING_FORGE_BUTTON_PETS_DESC"],
				filters_widgets = function()
					if (not DetailsForgeAllPetsFilterPanel) then
						local w = CreateFrame ("frame", "DetailsForgeAllPetsFilterPanel", f)
						w:SetSize (600, 20)
						w:SetPoint ("topleft", f, "topleft", 164, -40)
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_PETNAME"] .. ": ")
						label:SetPoint ("left", w, "left", 5, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllPetsNameFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_OWNERNAME"] .. ": ")
						label:SetPoint ("left", entry.widget, "right", 20, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllPetsOwnerFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
					end
					return DetailsForgeAllPetsFilterPanel
				end,
				search = function()
					local t = {}
					local filter_petname = DetailsForgeAllPetsNameFilter:GetText()
					local filter_ownername = DetailsForgeAllPetsOwnerFilter:GetText()
					for _, actor in ipairs (_detalhes:GetCombat("current"):GetActorList (DETAILS_ATTRIBUTE_DAMAGE)) do
						if (actor.owner) then
							local can_add = true
							if (filter_petname ~= "") then
								filter_petname = lower (filter_petname)
								local actor_name = lower (actor:name())
								if (not actor_name:find (filter_petname)) then
									can_add = false
								end
							end
							if (filter_ownername ~= "") then
								filter_ownername = lower (filter_ownername)
								local actor_name = lower (actor.ownerName)
								if (not actor_name:find (filter_ownername)) then
									can_add = false
								end
							end
							if (can_add) then
								t [#t+1] = actor
							end
						end
					end
					return t
				end,
				header = {
					{name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
					{name = L["STRING_FORGE_HEADER_NAME"], width = 150, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_OWNER"], width = 150, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_NPCID"], width = 60, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_GUID"], width = 100, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_FLAG"], width = 100, type = "entry", func = no_func},
				},
				fill_panel = false,
				fill_gettotal = function (self) return #self.module.data end,
				fill_fillrows = function (index, self) 
					local data = self.module.data [index]
					if (data) then
						return {
							index,
							data:name():gsub ("(<).*(>)", "") or "",
							data.ownerName or "",
							_detalhes:GetNpcIdFromGuid (data.serial),
							data.serial or "",
							"0x" .. _detalhes:hex (data.flag_original)
						}
					else
						return nothing_to_show
					end
				end,
				fill_name = "DetailsForgeAllPetsFillPanel",
			}
			

			
			-----------------------------------------------
			
			local all_enemies_module = {
				name = L["STRING_FORGE_BUTTON_ENEMIES"],
				desc = L["STRING_FORGE_BUTTON_ENEMIES_DESC"],
				filters_widgets = function()
					if (not DetailsForgeAllEnemiesFilterPanel) then
						local w = CreateFrame ("frame", "DetailsForgeAllEnemiesFilterPanel", f)
						w:SetSize (600, 20)
						w:SetPoint ("topleft", f, "topleft", 164, -40)
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_ENEMYNAME"] .. ": ")
						label:SetPoint ("left", w, "left", 5, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllEnemiesNameFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
					end
					return DetailsForgeAllEnemiesFilterPanel
				end,
				search = function()
					local t = {}
					local filter = DetailsForgeAllEnemiesNameFilter:GetText()
					for _, actor in ipairs (_detalhes:GetCombat("current"):GetActorList (DETAILS_ATTRIBUTE_DAMAGE)) do
						if (actor:IsNeutralOrEnemy()) then
							if (filter ~= "") then
								filter = lower (filter)
								local actor_name = lower (actor:name())
								if (actor_name:find (filter)) then
									t [#t+1] = actor
								end
							else
								t [#t+1] = actor
							end
						end
					end
					return t
				end,
				header = {
					{name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
					{name = L["STRING_FORGE_HEADER_NAME"], width = 150, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_NPCID"], width = 60, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_GUID"], width = 230, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_FLAG"], width = 100, type = "entry", func = no_func},
				},
				fill_panel = false,
				fill_gettotal = function (self) return #self.module.data end,
				fill_fillrows = function (index, self) 
					local data = self.module.data [index]
					if (data) then
						return {
							index,
							data:name(),
							_detalhes:GetNpcIdFromGuid (data.serial),
							data.serial or "",
							"0x" .. _detalhes:hex (data.flag_original)
						}
					else
						return nothing_to_show
					end
				end,
				fill_name = "DetailsForgeAllEnemiesFillPanel",
			}

			-----------------------------------------------
			
			local spell_open_aura_creator = function (row)
				local data = all_modules [2].data [row]
				local spellid = data[1]
				local spellname, _, spellicon = GetSpellInfo (spellid)
				_detalhes:OpenAuraPanel (spellid, spellname, spellicon, data[3])
			end
			
			local spell_encounter_open_aura_creator = function (row)
				local data = all_modules [1].data [row]
				local spellID = data[1]
				local encounterID  = data [2]
				local enemyName = data [3]
				local encounterName = data [4]
				
				local spellname, _, spellicon = GetSpellInfo (spellID)
				
				_detalhes:OpenAuraPanel (spellID, spellname, spellicon, encounterID)
			end
			
			local EncounterSpellEvents = EncounterDetailsDB and EncounterDetailsDB.encounter_spells
			
			local all_spells_module = {
				name = L["STRING_FORGE_BUTTON_ALLSPELLS"],
				desc = L["STRING_FORGE_BUTTON_ALLSPELLS_DESC"],
				filters_widgets = function()
					if (not DetailsForgeAllSpellsFilterPanel) then
						local w = CreateFrame ("frame", "DetailsForgeAllSpellsFilterPanel", f)
						w:SetSize (600, 20)
						w:SetPoint ("topleft", f, "topleft", 164, -40)
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_SPELLNAME"] .. ": ")
						label:SetPoint ("left", w, "left", 5, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllSpellsNameFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_CASTERNAME"] .. ": ")
						label:SetPoint ("left", entry.widget, "right", 20, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllSpellsCasterFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
					end
					return DetailsForgeAllSpellsFilterPanel
				end,
				search = function()
					local t = {}
					local filter_caster = DetailsForgeAllSpellsCasterFilter:GetText()
					local filter_name = DetailsForgeAllSpellsNameFilter:GetText()
					local lower_FilterCaster = lower (filter_caster)
					local lower_FilterSpellName = lower (filter_name)
					wipe (spell_already_added)
					
					local SpellPoll = _detalhes.spell_pool
					for spellID, className in pairs (SpellPoll) do
						
						if (type (spellID) == "number" and spellID > 12) then

							local can_add = true
							
							if (lower_FilterCaster ~= "") then
								--class name are stored as numbers for players and string for non-player characters
								local classNameOriginal = className
								if (type (className) == "number") then
									className = _detalhes.classid_to_classstring [className]
									className = lower (className)
								else
									className = lower (className)
								end
								
								if (not className:find (lower_FilterCaster)) then
									can_add = false
								else
									className = classNameOriginal
								end
							end
							
							if (can_add	) then
								if (filter_name ~= "") then
									local spellName = GetSpellInfo (spellID)
									if (spellName) then
										spellName = lower (spellName)
										if (not spellName:find (lower_FilterSpellName)) then
											can_add = false
										end
									else
										can_add = false
									end
								end
							end
							
							if (can_add) then
								tinsert (t, {spellID, _detalhes.classid_to_classstring [className] or className})
							end
							
						end
					end
					
					return t
				end,
				header = {
					{name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
					{name = L["STRING_FORGE_HEADER_ICON"], width = 40, type = "texture"},
					{name = L["STRING_FORGE_HEADER_NAME"], width = 150, type = "entry", func = no_func, onenter = function(self) GameTooltip:SetOwner (self.widget, "ANCHOR_TOPLEFT"); _detalhes:GameTooltipSetSpellByID (self.id); GameTooltip:Show() end, onleave = function(self) GameTooltip:Hide() end},
					{name = L["STRING_FORGE_HEADER_SPELLID"], width = 60, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_SCHOOL"], width = 60, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_CASTER"], width = 120, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_EVENT"], width = 180, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_CREATEAURA"], width = 86, type = "button", func = spell_open_aura_creator, icon = [[Interface\AddOns\WeakAuras\Media\Textures\icon]], notext = true, iconalign = "center"},
				},
				fill_panel = false,
				fill_gettotal = function (self) return #self.module.data end,
				fill_fillrows = function (index, self) 
					local data = self.module.data [index]
					if (data) then
						local events = ""
						if (EncounterSpellEvents and EncounterSpellEvents [data[1]]) then
							for token, _ in pairs (EncounterSpellEvents [data[1]].token) do
								token = token:gsub ("SPELL_", "")
								events = events .. token .. ",  "
							end
							events = events:sub (1, #events - 3)
						end
						local spellName, _, spellIcon = GetSpellInfo (data[1])
						local classColor = RAID_CLASS_COLORS [data[2]] and RAID_CLASS_COLORS [data[2]].colorStr or "FFFFFFFF"
						return {
							index,
							spellIcon,
							{text = spellName or "", id = data[1] or 1},
							data[1] or "",
							_detalhes:GetSpellSchoolFormatedName (_detalhes.spell_school_cache [spellName]) or "",
							"|c" .. classColor .. data[2] .. "|r",
							events
						}
					else
						return nothing_to_show
					end
				end,
				fill_name = "DetailsForgeAllSpellsFillPanel",
			}
			
			
			-----------------------------------------------
			
			
			local encounter_spells_module = {
				name = L["STRING_FORGE_BUTTON_ENCOUNTERSPELLS"],
				desc = L["STRING_FORGE_BUTTON_ENCOUNTERSPELLS_DESC"],
				filters_widgets = function()
					if (not DetailsForgeEncounterBossSpellsFilterPanel) then
					
						local w = CreateFrame ("frame", "DetailsForgeEncounterBossSpellsFilterPanel", f)
						w:SetSize (600, 20)
						w:SetPoint ("topleft", f, "topleft", 164, -40)
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_SPELLNAME"] .. ": ")
						label:SetPoint ("left", w, "left", 5, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeEncounterSpellsNameFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_CASTERNAME"] .. ": ")
						label:SetPoint ("left", entry.widget, "right", 20, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeEncounterSpellsCasterFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_ENCOUNTERNAME"] .. ": ")
						label:SetPoint ("left", entry.widget, "right", 20, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeEncounterSpellsEncounterFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
					end
					return DetailsForgeEncounterBossSpellsFilterPanel
				end,
				search = function()
					local t = {}
					
					local filter_name = DetailsForgeEncounterSpellsNameFilter:GetText()
					local filter_caster = DetailsForgeEncounterSpellsCasterFilter:GetText()
					local filter_encounter = DetailsForgeEncounterSpellsEncounterFilter:GetText()
					
					local lower_FilterCaster = lower (filter_caster)
					local lower_FilterSpellName = lower (filter_name)
					local lower_FilterEncounterName = lower (filter_encounter)
					
					wipe (spell_already_added)
					
					local SpellPoll = _detalhes.encounter_spell_pool
					for spellID, spellTable in pairs (SpellPoll) do
						if (spellID > 12) then

							local encounterID = spellTable [1]
							local enemyName = spellTable [2]
							local bossDetails, bossIndex = _detalhes:GetBossEncounterDetailsFromEncounterId (nil, encounterID)
							
							local can_add = true
							
							if (lower_FilterCaster ~= "") then
								if (not lower (enemyName):find (lower_FilterCaster)) then
									can_add = false
								end
							end
							
							if (can_add	) then
								if (filter_name ~= "") then
									local spellName = GetSpellInfo (spellID)
									if (spellName) then
										spellName = lower (spellName)
										if (not spellName:find (lower_FilterSpellName)) then
											can_add = false
										end
									else
										can_add = false
									end
								end
							end
							
							if (can_add and bossDetails) then
								local encounterName = bossDetails.boss
								if (filter_encounter ~= "" and encounterName and encounterName ~= "") then
									encounterName = lower (encounterName)
									if (not encounterName:find (lower_FilterEncounterName)) then
										can_add = false
									end
								end
							end
							
							if (can_add) then
								tinsert (t, {spellID, encounterID, enemyName, bossDetails and bossDetails.boss or "--x--x--"})
							end
						end
					end
					
					return t
				end,
				
				header = {
					{name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
					{name = L["STRING_FORGE_HEADER_ICON"], width = 40, type = "texture"},
					{name = L["STRING_FORGE_HEADER_NAME"], width = 151, type = "entry", func = no_func, onenter = function(self) GameTooltip:SetOwner (self.widget, "ANCHOR_TOPLEFT"); _detalhes:GameTooltipSetSpellByID (self.id); GameTooltip:Show() end, onleave = function(self) GameTooltip:Hide() end},
					{name = L["STRING_FORGE_HEADER_SPELLID"], width = 55, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_SCHOOL"], width = 60, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_CASTER"], width = 80, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_EVENT"], width = 150, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_ENCOUNTERNAME"], width = 95, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_CREATEAURA"], width = 86, type = "button", func = spell_encounter_open_aura_creator, icon = [[Interface\AddOns\WeakAuras\Media\Textures\icon]], notext = true, iconalign = "center"},
				},
				
				fill_panel = false,
				fill_gettotal = function (self) return #self.module.data end,
				fill_fillrows = function (index, self) 
					local data = self.module.data [index]
					if (data) then
					
						local events = ""
						if (EncounterSpellEvents and EncounterSpellEvents [data[1]]) then
							for token, _ in pairs (EncounterSpellEvents [data[1]].token) do
								token = token:gsub ("SPELL_", "")
								events = events .. token .. ",  "
							end
							events = events:sub (1, #events - 3)
						end
						
						local spellName, _, spellIcon = GetSpellInfo (data[1])
						
						return {
							index,
							spellIcon,
							{text = spellName or "", id = data[1] or 1},
							data[1] or "",
							_detalhes:GetSpellSchoolFormatedName (_detalhes.spell_school_cache [spellName]) or "",
							data[3] .. "|r",
							events,
							data[4],
						}
					else
						return nothing_to_show
					end
				end,
				fill_name = "DetailsForgeEncounterBossSpellsFillPanel",
			}			
			
			
			-----------------------------------------------
			
			local npc_ids_module = {
				name = "Npc IDs",
				desc = "Show a list of known npc IDs",
				filters_widgets = function()
					if (not DetailsForgeEncounterNpcIDsFilterPanel) then
					
						local w = CreateFrame ("frame", "DetailsForgeEncounterNpcIDsFilterPanel", f)
						w:SetSize (600, 20)
						w:SetPoint ("topleft", f, "topleft", 164, -40)
						--npc name filter
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText ("Npc Name" .. ": ")
						label:SetPoint ("left", w, "left", 5, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeEncounterNpcIDsFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
						--
					end
					return DetailsForgeEncounterNpcIDsFilterPanel
				end,
				search = function()
					local t = {}
					
					local filter_name = DetailsForgeEncounterNpcIDsFilter:GetText()
					local lower_FilterNpcName = lower (filter_name)
					
					local npcPool = _detalhes.npcid_pool
					for npcID, npcName in pairs (npcPool) do
						local can_add = true
						
						if (lower_FilterNpcName ~= "") then
							if (not lower (npcName):find (lower_FilterNpcName)) then
								can_add = false
							end
						end
						
						if (can_add) then
							tinsert (t, {npcID, npcName})
						end
						
						table.sort (t, DetailsFramework.SortOrder2R)
					end
					
					return t
				end,
				
				header = {
					{name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
					{name = "NpcID", width = 100, type = "entry", func = no_func},
					{name = "Npc Name", width = 400, type = "entry", func = no_func},
				},
				
				fill_panel = false,
				fill_gettotal = function (self) return #self.module.data end,
				fill_fillrows = function (index, self) 
					local data = self.module.data [index]
					if (data) then
						local events = ""
						if (EncounterSpellEvents and EncounterSpellEvents [data[1]]) then
							for token, _ in pairs (EncounterSpellEvents [data[1]].token) do
								token = token:gsub ("SPELL_", "")
								events = events .. token .. ",  "
							end
							events = events:sub (1, #events - 3)
						end

						return {
							index,
							data[1],
							data[2]
						}
					else
						return nothing_to_show
					end
				end,
				fill_name = "DetailsForgeNpcIDsFillPanel",
			}	
			
			-----------------------------------------------
			
			local dbm_open_aura_creator = function (row)
				local data = all_modules [4].data [row]
				
				local spellname, spellicon, _
				if (type (data [7]) == "number") then
					spellname, _, spellicon = GetSpellInfo (data [7])
				else
					if (data [7]) then
						local spellid = data[7]:gsub ("ej", "")
						spellid = tonumber (spellid)
						local title, description, depth, abilityIcon, displayInfo, siblingID, nextSectionID, filteredByDifficulty, link, startsOpen, flag1, flag2, flag3, flag4 = DetailsFramework.EncounterJournal.EJ_GetSectionInfo (spellid)
						spellname, spellicon = title, abilityIcon
					else
						return
					end
				end
				
				_detalhes:OpenAuraPanel (data[2], spellname, spellicon, data.id, DETAILS_WA_TRIGGER_DBM_TIMER, DETAILS_WA_AURATYPE_TEXT, {dbm_timer_id = data[2], spellid = data[7], text = "Next " .. spellname .. " In", text_size = 72, icon = spellicon})
			end
			
			local dbm_timers_module = {
				name = L["STRING_FORGE_BUTTON_DBMTIMERS"],
				desc = L["STRING_FORGE_BUTTON_DBMTIMERS_DESC"],
				filters_widgets = function()
					if (not DetailsForgeDBMBarsFilterPanel) then
						local w = CreateFrame ("frame", "DetailsForgeDBMBarsFilterPanel", f)
						w:SetSize (600, 20)
						w:SetPoint ("topleft", f, "topleft", 164, -40)
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_BARTEXT"] .. ": ")
						label:SetPoint ("left", w, "left", 5, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeDBMBarsTextFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_ENCOUNTERNAME"] .. ": ")
						label:SetPoint ("left", entry.widget, "right", 20, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeDBMBarsEncounterFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
					end
					return DetailsForgeDBMBarsFilterPanel
				end,
				search = function()
					local t = {}
					local filter_barname = DetailsForgeDBMBarsTextFilter:GetText()
					local filter_encounter = DetailsForgeDBMBarsEncounterFilter:GetText()
					
					local lower_FilterBarName = lower (filter_barname)
					local lower_FilterEncounterName = lower (filter_encounter)
					
					local source = _detalhes.boss_mods_timers.encounter_timers_dbm or {}
					
					for key, timer in pairs (source) do
						local can_add = true
						if (lower_FilterBarName ~= "") then
							if (not lower (timer [3]):find (lower_FilterBarName)) then
								can_add = false
							end
						end
						if (lower_FilterEncounterName ~= "") then
							local bossDetails, bossIndex = _detalhes:GetBossEncounterDetailsFromEncounterId (nil, timer.id)
							local encounterName = bossDetails and bossDetails.boss
							if (encounterName and encounterName ~= "") then
								encounterName = lower (encounterName)
								if (not encounterName:find (lower_FilterEncounterName)) then
									can_add = false
								end
							end
						end
						
						if (can_add) then
							t [#t+1] = timer
						end
					end
					return t
				end,
				header = {
					{name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
					{name = L["STRING_FORGE_HEADER_ICON"], width = 40, type = "texture"},
					{name = L["STRING_FORGE_HEADER_BARTEXT"], width = 150, type = "entry", func = no_func, onenter = function(self) GameTooltip:SetOwner (self.widget, "ANCHOR_TOPLEFT"); _detalhes:GameTooltipSetSpellByID (self.id); GameTooltip:Show() end, onleave = function(self) GameTooltip:Hide() end},
					{name = L["STRING_FORGE_HEADER_ID"], width = 130, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_SPELLID"], width = 50, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_TIMER"], width = 40, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_ENCOUNTERID"], width = 80, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_ENCOUNTERNAME"], width = 110, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_CREATEAURA"], width = 80, type = "button", func = dbm_open_aura_creator, icon = [[Interface\AddOns\WeakAuras\Media\Textures\icon]], notext = true, iconalign = "center"},
				},
				
				fill_panel = false,
				fill_gettotal = function (self) return #self.module.data end,
				fill_fillrows = function (index, self) 
					local data = self.module.data [index]
					if (data) then
						local encounter_id = data.id
						local bossDetails, bossIndex = _detalhes:GetBossEncounterDetailsFromEncounterId (nil, data.id)
						local bossName = bossDetails and bossDetails.boss or "--x--x--"

						local abilityID = tonumber (data [7])
						local spellName, _, spellIcon
						if (abilityID) then
							if (abilityID > 0) then
								spellName, _, spellIcon = GetSpellInfo (abilityID)
							end
						end
						
						return {
							index,
							spellIcon,
							{text = data[3] or "", id = abilityID and abilityID > 0 and abilityID or 0},
							data[2] or "",
							data[7] or "",
							data[4] or "0",
							tostring (encounter_id) or "0",
							bossName,
						}
					else
						return nothing_to_show
					end
				end,
				fill_name = "DetailsForgeDBMBarsFillPanel",
			}
			
			-----------------------------------------------
			
			local bw_open_aura_creator = function (row)
			
				local data = all_modules [5].data [row]
				
				local spellname, spellicon, _
				local spellid = tonumber (data [2])
				
				if (type (spellid) == "number") then
					if (spellid < 0) then
						local title, description, depth, abilityIcon, displayInfo, siblingID, nextSectionID, filteredByDifficulty, link, startsOpen, flag1, flag2, flag3, flag4 = DetailsFramework.EncounterJournal.EJ_GetSectionInfo (abs (spellid))
						spellname, spellicon = title, abilityIcon
					else
						spellname, _, spellicon = GetSpellInfo (spellid)
					end
					_detalhes:OpenAuraPanel (data [2], spellname, spellicon, data.id, DETAILS_WA_TRIGGER_BW_TIMER, DETAILS_WA_AURATYPE_TEXT, {bw_timer_id = data [2], text = "Next " .. spellname .. " In", text_size = 72, icon = spellicon})
					
				elseif (type (data [2]) == "string") then
					--> "Xhul'horac" Imps
					_detalhes:OpenAuraPanel (data [2], data[3], data[5], data.id, DETAILS_WA_TRIGGER_BW_TIMER, DETAILS_WA_AURATYPE_TEXT, {bw_timer_id = data [2], text = "Next " .. (data[3] or "") .. " In", text_size = 72, icon = data[5]})
				end
			end
			
			local bigwigs_timers_module = {
				name = L["STRING_FORGE_BUTTON_BWTIMERS"],
				desc = L["STRING_FORGE_BUTTON_BWTIMERS_DESC"],
				filters_widgets = function()
					if (not DetailsForgeBigWigsBarsFilterPanel) then
						local w = CreateFrame ("frame", "DetailsForgeBigWigsBarsFilterPanel", f)
						w:SetSize (600, 20)
						w:SetPoint ("topleft", f, "topleft", 164, -40)
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_BARTEXT"] .. ": ")
						label:SetPoint ("left", w, "left", 5, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeBigWigsBarsTextFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
						--
						local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
						label:SetText (L["STRING_FORGE_FILTER_ENCOUNTERNAME"] .. ": ")
						label:SetPoint ("left", entry.widget, "right", 20, 0)
						local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeBWBarsEncounterFilter")
						entry:SetHook ("OnTextChanged", function() f:refresh() end)
						entry:SetPoint ("left", label, "right", 2, 0)
						entry:SetTemplate (_detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
						--
					end
					return DetailsForgeBigWigsBarsFilterPanel
				end,
				search = function()
					local t = {}
					
					local filter_barname = DetailsForgeBigWigsBarsTextFilter:GetText()
					local filter_encounter = DetailsForgeBWBarsEncounterFilter:GetText()

					local lower_FilterBarName = lower (filter_barname)
					local lower_FilterEncounterName = lower (filter_encounter)
					
					
					local source = _detalhes.boss_mods_timers.encounter_timers_bw or {}
					for key, timer in pairs (source) do
						local can_add = true
						if (lower_FilterBarName ~= "") then
							if (not lower (timer [3]):find (lower_FilterBarName)) then
								can_add = false
							end
						end
						if (lower_FilterEncounterName ~= "") then
							local bossDetails, bossIndex = _detalhes:GetBossEncounterDetailsFromEncounterId (nil, timer.id)
							local encounterName = bossDetails and bossDetails.boss
							if (encounterName and encounterName ~= "") then
								encounterName = lower (encounterName)
								if (not encounterName:find (lower_FilterEncounterName)) then
									can_add = false
								end
							end
						end
						
						if (can_add) then
							t [#t+1] = timer
						end
					end
					return t
				end,
				header = {
					{name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
					{name = L["STRING_FORGE_HEADER_ICON"], width = 40, type = "texture"},
					{name = L["STRING_FORGE_HEADER_BARTEXT"], width = 200, type = "entry", func = no_func, onenter = function(self) GameTooltip:SetOwner (self.widget, "ANCHOR_TOPLEFT"); _detalhes:GameTooltipSetSpellByID (self.id); GameTooltip:Show() end, onleave = function(self) GameTooltip:Hide() end},
					{name = L["STRING_FORGE_HEADER_SPELLID"], width = 50, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_TIMER"], width = 40, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_ENCOUNTERID"], width = 80, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_ENCOUNTERNAME"], width = 120, type = "entry", func = no_func},
					{name = L["STRING_FORGE_HEADER_CREATEAURA"], width = 120, type = "button", func = bw_open_aura_creator, icon = [[Interface\AddOns\WeakAuras\Media\Textures\icon]], notext = true, iconalign = "center"},
				},
				fill_panel = false,
				fill_gettotal = function (self) return #self.module.data end,
				fill_fillrows = function (index, self) 
					local data = self.module.data [index]
					if (data) then
						local encounter_id = data.id
						local bossDetails, bossIndex = _detalhes:GetBossEncounterDetailsFromEncounterId (nil, data.id)
						local bossName = bossDetails and bossDetails.boss or "--x--x--"
						
						local abilityID = tonumber (data[2])
						local spellName, _, spellIcon
						if (abilityID) then
							if (abilityID > 0) then
								spellName, _, spellIcon = GetSpellInfo (abilityID)
							end
						end

						return {
							index,
							spellIcon,
							{text = data[3] or "", id = abilityID and abilityID > 0 and abilityID or 0},
							data[2] or "",
							data[4] or "",
							tostring (encounter_id) or "0",
							bossName
						}
					else
						return nothing_to_show
					end
				end,
				fill_name = "DetailsForgeBigWigsBarsFillPanel",
			}
			
			-----------------------------------------------
			


			local select_module = function (a, b, module_number)
			
				if (current_module ~= module_number) then
					local module = all_modules [current_module]
					if (module) then
						local filters = module.filters_widgets()
						filters:Hide()
						local fill_panel = module.fill_panel
						fill_panel:Hide()
					end
				end
				
				for index, button in ipairs (buttons) do
					button:SetTemplate (CONST_BUTTON_TEMPLATE)
				end
				buttons[module_number]:SetTemplate (CONST_BUTTONSELECTED_TEMPLATE)
				
				local module = all_modules [module_number]
				if (module) then
					current_module = module_number
					
					local fillpanel = module.fill_panel
					if (not fillpanel) then
						fillpanel = fw:NewFillPanel (f, module.header, module.fill_name, nil, 740, 481, module.fill_gettotal, module.fill_fillrows, false)
						fillpanel:SetPoint (170, -80)
						fillpanel.module = module
						
						local background = fillpanel:CreateTexture (nil, "background")
						background:SetAllPoints()
						background:SetColorTexture (0, 0, 0, 0.2)
						
						module.fill_panel = fillpanel
					end
					
					local filters = module.filters_widgets()
					filters:Show()
					
					local data = module.search()
					module.data = data
					
					fillpanel:Show()
					fillpanel:Refresh()
					
					for o = 1, #fillpanel.scrollframe.lines do
						for i = 1, #fillpanel.scrollframe.lines [o].entry_inuse do
							--> text entry
							fillpanel.scrollframe.lines [o].entry_inuse [i]:SetTemplate (fw:GetTemplate ("button", "DETAILS_FORGE_TEXTENTRY_TEMPLATE"))
						end
					end
				end
			end
			
			function f:refresh()
				select_module (nil, nil, current_module)
			end
			
			f.SelectModule = select_module
			f.AllModules = all_modules

			f:InstallModule (encounter_spells_module)
			f:InstallModule (all_spells_module)
			
			f:InstallModule (npc_ids_module)
			
			f:InstallModule (dbm_timers_module)
			f:InstallModule (bigwigs_timers_module)
			
			f:InstallModule (all_players_module)
			f:InstallModule (all_enemies_module)
			f:InstallModule (all_pets_module)

			local brackets = {
				[4] = true, 
				[6] = true
			}
			local lastButton
			
			for i = 1, #all_modules do
				local module = all_modules [i]
				local b = fw:CreateButton (f, select_module, 140, 20, module.name, i)
				b.tooltip = module.desc
				
				b:SetTemplate (CONST_BUTTON_TEMPLATE)
				b:SetIcon ([[Interface\BUTTONS\UI-GuildButton-PublicNote-Up]], nil, nil, nil, nil, {1, 1, 1, 0.7})
				b:SetWidth (140)
				
				if (lastButton) then
					if (brackets [i]) then
						b:SetPoint ("topleft", lastButton, "bottomleft", 0, -23)
					else
						b:SetPoint ("topleft", lastButton, "bottomleft", 0, -8)
					end
				else
					b:SetPoint ("topleft", f, "topleft", 10, (i*16*-1) - 67)
				end

				lastButton = b
				tinsert (buttons, b)
			end

			select_module (nil, nil, 1)
			
		end

		DetailsForgePanel:Show()
		
		--do a refresh on the panel
		if (DetailsForgePanel.FirstRun) then
			DetailsForgePanel:refresh()
		else
			DetailsForgePanel.FirstRun = true
		end
		
		DetailsPluginContainerWindow.OpenPlugin (DetailsForgePanel)
		
	end

	--_detalhes:ScheduleTimer ("OpenForge", 3)
	
----------------------------------------------------------------------------------------------------------------------------------

--framename: 
-- DeathRecapFrame
-- OpenDeathRecapUI()
-- Blizzard_DeathRecap

local textAlpha = 0.9

local on_deathrecap_line_enter = function (self)
	if (self.spellid) then
		GameTooltip:SetOwner (self, "ANCHOR_RIGHT")
		_detalhes:GameTooltipSetSpellByID (self.spellid)
		self:SetBackdropColor (.3, .3, .3, .2)
		GameTooltip:Show()
		self.backgroundTextureOverlay:Show()
		self.timeAt:SetAlpha (1)
		self.sourceName:SetAlpha (1)
		self.amount:SetAlpha (1)
		self.lifePercent:SetAlpha (1)
	end
end
local on_deathrecap_line_leave = function (self)
	GameTooltip:Hide()
	self:SetBackdropColor (.3, .3, .3, 0)
	self.backgroundTextureOverlay:Hide()
	self.timeAt:SetAlpha (textAlpha)
	self.sourceName:SetAlpha (textAlpha)
	self.amount:SetAlpha (textAlpha)
	self.lifePercent:SetAlpha (textAlpha)
end

local create_deathrecap_line = function (parent, n)
	local line = CreateFrame ("frame", "DetailsDeathRecapLine" .. n, parent)
	line:SetPoint ("topleft", parent, "topleft", 10, (-24 * n) - 17)
	line:SetPoint ("topright", parent, "topright", -10, (-24 * n) - 17)
	--line:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
	--insets = {left = 0, right = 0, top = 0, bottom = 0}})
	line:SetScript ("OnEnter", on_deathrecap_line_enter)
	line:SetScript ("OnLeave", on_deathrecap_line_leave)
	
	line:SetSize (300, 21)
	
	if (n % 2 == 0) then
		--line:SetBackdropColor (0, 0, 0, 0)
	else
		--line:SetBackdropColor (.3, .3, .3, 0)
	end
	
	local timeAt = line:CreateFontString (nil, "overlay", "GameFontNormal")
	local backgroundTexture = line:CreateTexture (nil, "border")
	local backgroundTextureOverlay = line:CreateTexture (nil, "artwork")
	local spellIcon = line:CreateTexture (nil, "overlay")
	local spellIconBorder = line:CreateTexture (nil, "overlay")
	spellIcon:SetDrawLayer ("overlay", 1)
	spellIconBorder:SetDrawLayer ("overlay", 2)
	local sourceName = line:CreateFontString (nil, "overlay", "GameFontNormal")
	local amount = line:CreateFontString (nil, "overlay", "GameFontNormal")
	local lifePercent = line:CreateFontString (nil, "overlay", "GameFontNormal")
	
	--grave icon
	local graveIcon = line:CreateTexture (nil, "overlay")
	graveIcon:SetTexture ([[Interface\MINIMAP\POIIcons]])
	graveIcon:SetTexCoord (146/256, 160/256, 0/512, 18/512)
	graveIcon:SetPoint ("left", line, "left", 11, 0)
	graveIcon:SetSize (14, 18)
	
	--spell icon
	spellIcon:SetSize (19, 19)
	spellIconBorder:SetTexture ([[Interface\ENCOUNTERJOURNAL\LootTab]])
	spellIconBorder:SetTexCoord (6/256, 38/256, 49/128, 81/128)
	spellIconBorder:SetSize (20, 20)
	spellIconBorder:SetPoint ("topleft", spellIcon, "topleft", 0, 0)

	--locations
	timeAt:SetPoint ("left", line, "left", 2, 0)
	spellIcon:SetPoint ("left", line, "left", 50, 0)
	sourceName:SetPoint ("left", line, "left", 82, 0)
	amount:SetPoint ("left", line, "left", 240, 0)
	lifePercent:SetPoint ("left", line, "left", 320, 0)
	
	--text colors
	_detalhes.gump:SetFontColor (amount, "red")
	_detalhes.gump:SetFontColor (timeAt, "gray")
	_detalhes.gump:SetFontColor (sourceName, "yellow")
	
	_detalhes.gump:SetFontSize (sourceName, 10)

	--text alpha
	timeAt:SetAlpha (textAlpha)
	sourceName:SetAlpha (textAlpha)
	amount:SetAlpha (textAlpha)
	lifePercent:SetAlpha (textAlpha)
	
	--text setup
	amount:SetWidth (85)
	amount:SetJustifyH ("right")
	lifePercent:SetWidth (42)
	lifePercent:SetJustifyH ("right")
	
	--background
	--backgroundTexture:SetTexture ([[Interface\AdventureMap\AdventureMap]])
	--backgroundTexture:SetTexCoord (460/1024, 659/1024, 330/1024, 350/1024)
	
	backgroundTexture:SetTexture ([[Interface\AddOns\Details\images\deathrecap_background]])
	backgroundTexture:SetTexCoord (0, 1, 0, 1)
	backgroundTexture:SetVertexColor (.1, .1, .1, .3)
	

	--top border
	local TopFader = line:CreateTexture (nil, "border")
	TopFader:SetTexture ([[Interface\AddOns\Details\images\deathrecap_background_top]])
	TopFader:SetTexCoord (0, 1, 0, 1)
	TopFader:SetVertexColor (.1, .1, .1, .3)
	TopFader:SetPoint ("bottomleft", backgroundTexture, "topleft", 0, -0)
	TopFader:SetPoint ("bottomright", backgroundTexture, "topright", 0, -0)
	TopFader:SetHeight (32)
	TopFader:Hide()
	line.TopFader = TopFader
	
	if (n == 10) then
		--bottom fader
		local backgroundTexture2 = line:CreateTexture (nil, "border")
		backgroundTexture2:SetTexture ([[Interface\AddOns\Details\images\deathrecap_background_bottom]])
		backgroundTexture2:SetTexCoord (0, 1, 0, 1)
		backgroundTexture2:SetVertexColor (.1, .1, .1, .3)	
		backgroundTexture2:SetPoint ("topleft", backgroundTexture, "bottomleft", 0, 0)
		backgroundTexture2:SetPoint ("topright", backgroundTexture, "bottomright", 0, 0)
		backgroundTexture2:SetHeight (32)

		--_detalhes.gump:SetFontColor (amount, "red")
		_detalhes.gump:SetFontSize (amount, 14)
		_detalhes.gump:SetFontSize (lifePercent, 14)
		backgroundTexture:SetVertexColor (.2, .1, .1, .3)
		
	end
	
	--backgroundTexture:SetAllPoints()
	backgroundTexture:SetPoint ("topleft", 0, 1)
	backgroundTexture:SetPoint ("bottomright", 0, -1)
	backgroundTexture:SetDesaturated (true)
	backgroundTextureOverlay:SetTexture ([[Interface\AdventureMap\AdventureMap]])
	backgroundTextureOverlay:SetTexCoord (460/1024, 659/1024, 330/1024, 350/1024)
	backgroundTextureOverlay:SetAllPoints()
	backgroundTextureOverlay:SetDesaturated (true)
	backgroundTextureOverlay:SetAlpha (0.5)
	backgroundTextureOverlay:Hide()
	
	line.timeAt = timeAt
	line.spellIcon = spellIcon
	line.sourceName = sourceName
	line.amount = amount
	line.lifePercent = lifePercent
	line.backgroundTexture = backgroundTexture
	line.backgroundTextureOverlay = backgroundTextureOverlay
	line.graveIcon = graveIcon
	
	if (n == 10) then
		graveIcon:Show()
		line.timeAt:Hide()
	else
		graveIcon:Hide()
	end
	
	return line
end

local OpenDetailsDeathRecapAtSegment = function (segment)
	_detalhes.OpenDetailsDeathRecap (segment, RecapID)
end

function _detalhes.BuildDeathTableFromRecap (recapID)
	local events = DeathRecap_GetEvents (recapID)
	
	--check if it is a valid recap
	if (not events or #events <= 0) then
		DeathRecapFrame.Unavailable:Show()
		return
	end
	
	--build an death log using details format
	ArtificialDeathLog = {
		{}, --deathlog events
		(events [1] and events [1].timestamp) or (DeathRecapFrame and DeathRecapFrame.DeathTimeStamp) or 0, --time of death
		UnitName ("player"),
		select (2, UnitClass ("player")),
		UnitHealthMax ("player"),
		"0m 0s", --formated fight time
		["dead"] = true,
		["last_cooldown"] = false,
		["dead_at"] = 0,
		n = 1
	}
	
	for i = 1, #events do
		local evtData = events [i]
		local spellId, spellName, texture = DeathRecapFrame_GetEventInfo ( evtData )	

		local ev = {
			true, 
			spellId or 0, 
			evtData.amount or 0,
			evtData.timestamp or 0, --?
			evtData.currentHP or 0,
			evtData.sourceName or "--x--x--",
			evtData.absorbed or 0,
			evtData.school or 0,
			false,
			evtData.overkill,
			not spellId and {spellId, spellName, texture},
		}
		
		tinsert (ArtificialDeathLog[1], ev)
		ArtificialDeathLog.n = ArtificialDeathLog.n + 1
	end
	
	return ArtificialDeathLog
end

function _detalhes.GetDeathRecapFromChat()
	-- /dump ChatFrame1:GetMessageInfo (i)
	-- /dump ChatFrame1:GetNumMessages()
	local chat1 = ChatFrame1
	local recapIDFromChat
	if (chat1) then
		local numLines = chat1:GetNumMessages()
		for i = numLines, 1, -1 do
			local text = chat1:GetMessageInfo (i)
			if (text) then
				if (text:find ("Hdeath:%d")) then
					local recapID = text:match ("|Hdeath:(%d+)|h")
					if (recapID) then
						recapIDFromChat = tonumber (recapID)
					end
					break
				end
			end
		end
	end
	
	if (recapIDFromChat) then
		_detalhes.OpenDetailsDeathRecap (nil, recapIDFromChat, true)
		return
	end
end

function _detalhes.OpenDetailsDeathRecap (segment, RecapID, fromChat)

		if (not _detalhes.death_recap.enabled) then
			if (Details.DeathRecap and Details.DeathRecap.Lines) then
				for i = 1, 10 do
					Details.DeathRecap.Lines [i]:Hide()
				end
				for i, button in ipairs (Details.DeathRecap.Segments) do
					button:Hide()
				end
			end

			return
		end
	
		DeathRecapFrame.Recap1:Hide()
		DeathRecapFrame.Recap2:Hide()
		DeathRecapFrame.Recap3:Hide()
		DeathRecapFrame.Recap4:Hide()
		DeathRecapFrame.Recap5:Hide()
		
		if (not Details.DeathRecap) then
			Details.DeathRecap = CreateFrame ("frame", "DetailsDeathRecap", DeathRecapFrame)
			Details.DeathRecap:SetAllPoints()
			
			DeathRecapFrame.Title:SetText (DeathRecapFrame.Title:GetText() .. " (by Details!)")
			
			--lines
			Details.DeathRecap.Lines = {}
			for i = 1, 10 do
				Details.DeathRecap.Lines [i] = create_deathrecap_line (Details.DeathRecap, i)
			end
			
			--segments
			Details.DeathRecap.Segments = {}
			for i = 5, 1, -1 do
				local segmentButton = CreateFrame ("button", "DetailsDeathRecapSegmentButton" .. i, Details.DeathRecap)
				
				segmentButton:SetSize (16, 20)
				segmentButton:SetPoint ("topright", DeathRecapFrame, "topright", (-abs (i-6) * 22) - 10, -5)
				
				local text = segmentButton:CreateFontString (nil, "overlay", "GameFontNormal")
				segmentButton.text = text
				text:SetText ("#" .. i)
				text:SetPoint ("center")
				_detalhes.gump:SetFontColor (text, "silver")
				
				segmentButton:SetScript ("OnClick", function()
					OpenDetailsDeathRecapAtSegment (i)
				end)
				tinsert (Details.DeathRecap.Segments, i, segmentButton)
			end
		end
		
		for i = 1, 10 do
			Details.DeathRecap.Lines [i]:Hide()
		end
	
		--segment to use
		local death = _detalhes.tabela_vigente.last_events_tables
		
		--see if this segment has a death for the player
		local foundPlayer = false
		for index = #death, 1, -1 do
			if (death [index] [3] == _detalhes.playername) then
				foundPlayer = true
				break
			end
		end

		--in case a combat has been created after the player death, the death won't be at the current segment
		if (not foundPlayer) then
			local segmentHistory = _detalhes:GetCombatSegments()
			for i = 1, 2 do
				local segment = segmentHistory [1]
				if (segment and segment ~= _detalhes.tabela_vigente) then
					if (_detalhes.tabela_vigente.start_time - 3 < segment.end_time) then
						death = segment.last_events_tables
					end
				end
			end
		end
		
		--segments
		if (_detalhes.death_recap.show_segments) then
			local last_index = 0
			local buttonsInUse = {}
			for i, button in ipairs (Details.DeathRecap.Segments) do
				if (_detalhes.tabela_historico.tabelas [i]) then
					button:Show()
					tinsert (buttonsInUse, button)
					_detalhes.gump:SetFontColor (button.text, "silver")
					last_index = i
				else
					button:Hide()
				end
			end
			
			local buttonsInUse2 = {}
			for i = #buttonsInUse, 1, -1 do
				tinsert (buttonsInUse2, buttonsInUse[i])
			end
			for i = 1, #buttonsInUse2 do
				local button = buttonsInUse2 [i]
				button:ClearAllPoints()
				button:SetPoint ("topright", DeathRecapFrame, "topright", (-i * 22) - 10, -5)
			end
			
			if (not segment) then
				_detalhes.gump:SetFontColor (Details.DeathRecap.Segments [1].text, "orange")
			else
				_detalhes.gump:SetFontColor (Details.DeathRecap.Segments [segment].text, "orange")
				death = _detalhes.tabela_historico.tabelas [segment] and _detalhes.tabela_historico.tabelas [segment].last_events_tables
			end
			
		else
			for i, button in ipairs (Details.DeathRecap.Segments) do
				button:Hide()
			end
		end

		--if couldn't find the requested log from details!, so, import the log from the blizzard death recap
		--or if the player cliced on the chat link for the recap
		local ArtificialDeathLog
		if (not death or RecapID) then
			if (segment) then
				--nop, the player requested a death log from details it self but the log does not exists
				DeathRecapFrame.Unavailable:Show()
				return
			end

			--get the death events from the blizzard's recap
			ArtificialDeathLog = _detalhes.BuildDeathTableFromRecap (RecapID)
		end
		
		DeathRecapFrame.Unavailable:Hide()
		
		--get the relevance config
		local relevanceTime = _detalhes.death_recap.relevance_time

		local t
		if (ArtificialDeathLog) then
			t = ArtificialDeathLog
		else
			for index = #death, 1, -1 do
				if (death [index] [3] == _detalhes.playername) then
					t = death [index]
					break
				end
			end
		end

		if (t) then
			local events = t [1]
			local timeOfDeath = t [2]
			
			local BiggestDamageHits = {}
			for i = #events, 1, -1 do
				tinsert (BiggestDamageHits, events [i])
			end
			table.sort (BiggestDamageHits, function (t1, t2) 
				return t1[3] > t2[3]
			end)
			for i = #BiggestDamageHits, 1, -1 do
				if (BiggestDamageHits [i][4] + relevanceTime < timeOfDeath) then
					tremove (BiggestDamageHits, i)
				end
			end
			
			--verifica se o evento que matou o jogador esta na lista, se nao, adiciona no primeiro index do BiggestDamageHits
			local hitKill
			for i = #events, 1, -1 do
				local event = events [i]
				local evType = event [1]
				if (type (evType) == "boolean" and evType) then
					hitKill = event
					break
				end
			end
			if (hitKill) then
				local haveHitKill = false
				for index, t in ipairs (BiggestDamageHits) do
					if (t == hitKill) then
						haveHitKill = true
						break
					end
				end
				if (not haveHitKill) then
					tinsert (BiggestDamageHits, 1, hitKill)
				end
			end

			--tem menos que 10 eventos com grande dano dentro dos ultimos 5 segundos
			--precisa preencher com danos pequenos
			
			--print ("1 BiggestDamageHits:", #BiggestDamageHits)
			
			if (#BiggestDamageHits < 10) then
				for i = #events, 1, -1 do
					local event = events [i]
					local evType = event [1]
					if (type (evType) == "boolean" and evType) then
						local alreadyHave = false
						for index, t in ipairs (BiggestDamageHits) do
							if (t == event) then
								alreadyHave = true
								break
							end
						end
						if (not alreadyHave) then
							tinsert (BiggestDamageHits, event)
							if (#BiggestDamageHits == 10) then
								break
							end
						end
					end
				end
			else
				--encurta a tabela em no maximo 10 eventos
				while (#BiggestDamageHits > 10) do 
					tremove (BiggestDamageHits, 11)
				end
			end

			if (#BiggestDamageHits == 0) then
				if (not fromChat) then
					_detalhes.GetDeathRecapFromChat()
					return
				end
			end	

			table.sort (BiggestDamageHits, function (t1, t2) 
				return t1[4] > t2[4]
			end)

			local events = BiggestDamageHits
			
			local maxHP = t [5]
			local lineIndex = 10
			
			--for i = #events, 1, -1 do
			for i, event in ipairs (events) do 
				local event = events [i]
				
				local evType = event [1]
				local hp = min (floor (event [5] / maxHP * 100), 100)
				local spellName, _, spellIcon = _detalhes.GetSpellInfo (event [2])
				local amount = event [3]
				local eventTime = event [4]
				local source = event [6]
				local overkill = event [10] or 0
				
				local customSpellInfo = event [11]
				
				--print ("3 loop", i, type (evType), evType)
				
				if (type (evType) == "boolean" and evType) then
					
					local line = Details.DeathRecap.Lines [lineIndex]
					--print ("4 loop", i, line)
					if (line) then
						line.timeAt:SetText (format ("%.1f", eventTime - timeOfDeath) .. "s")
						line.spellIcon:SetTexture (spellIcon or customSpellInfo and customSpellInfo [3] or "")
						line.TopFader:Hide()
						--line.spellIcon:SetTexCoord (.1, .9, .1, .9)
						--line.sourceName:SetText ("|cFFC6B0D9" .. source .. "|r")
						
						--parse source and cut the length of the string after setting the spellname and source
						local sourceClass = _detalhes:GetClass (source)
						local sourceSpec = _detalhes:GetSpec (source)
						
						if (not sourceClass) then
							local combat = Details:GetCurrentCombat()
							if (combat) then
								local sourceActor = combat:GetActor (1, source)
								if (sourceActor) then
									sourceClass = sourceActor.classe
								end
							end
						end
						
						if (not sourceSpec) then
							local combat = Details:GetCurrentCombat()
							if (combat) then
								local sourceActor = combat:GetActor (1, source)
								if (sourceActor) then
									sourceSpec = sourceActor.spec
								end
							end
						end
						
						--> remove real name or owner name
						source = _detalhes:GetOnlyName (source)
						--> remove owner name
						source = source:gsub ((" <.*"), "")
						
						--> if a player?
						if (_detalhes.player_class [sourceClass]) then
							source = _detalhes:AddClassOrSpecIcon (source, sourceClass, sourceSpec, 16, true)
							
						elseif (sourceClass == "PET") then
							source = _detalhes:AddClassOrSpecIcon (source, sourceClass)
						
						end

						--> remove the dot signal from the spell name
						if (not spellName) then
							spellName = customSpellInfo and customSpellInfo [2] or "*?*"
							if (spellName:find (STRING_ENVIRONMENTAL_DAMAGE_FALLING)) then
								if (UnitName ("player") == "Elphaba") then
									spellName = "Gravity Won!, Elphaba..."
									source = ""
								else
									source = "Gravity"
								end
								--/run for a,b in pairs (_G) do if (type (b)=="string" and b:find ("Falling")) then print (a,b) end end
							end
						end
						
						spellName = spellName:gsub (L["STRING_DOT"], "")
						spellName = spellName:gsub ("[*] ", "")
						--print ("link.lua", L["STRING_DOT"], spellName, spellName:find (L["STRING_DOT"]), spellName:gsub (L["STRING_DOT"], ""))
						source = source or ""
						
						line.sourceName:SetText (spellName .. " (" .. "|cFFC6B0D9" .. source .. "|r" .. ")")
						DetailsFramework:TruncateText (line.sourceName, 185)
						
						if (amount > 1000) then
							--line.amount:SetText ("-" .. _detalhes:ToK (amount))
							line.amount:SetText ("-" .. amount)
						else
							line.amount:SetText ("-" .. floor (amount))
						end
						
						line.lifePercent:SetText (hp .. "%")
						line.spellid = event [2]
						
						line:Show()
						
						if (_detalhes.death_recap.show_life_percent) then
							line.lifePercent:Show()
							line.amount:SetPoint ("left", line, "left", 240, 0)
							line.lifePercent:SetPoint ("left", line, "left", 320, 0)
						else
							line.lifePercent:Hide()
							line.amount:SetPoint ("left", line, "left", 280, 0)
							--line.lifePercent:SetPoint ("left", line, "left", 320, 0)
						end
					end
					
					lineIndex = lineIndex - 1
				end
			end
			
			local lastLine = Details.DeathRecap.Lines [lineIndex + 1]
			if (lastLine) then
				lastLine.TopFader:Show()
			end
			
			DeathRecapFrame.Unavailable:Hide()
		else
			if (not fromChat) then
				_detalhes.GetDeathRecapFromChat()
			end
		end

end

hooksecurefunc (_G, "DeathRecap_LoadUI", function()
	hooksecurefunc (_G, "DeathRecapFrame_OpenRecap", function (RecapID)
		_detalhes.OpenDetailsDeathRecap (nil, RecapID)
	end)
end)





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> plater integration

local plater_integration_frame = CreateFrame ("frame", "DetailsPlaterFrame", UIParent)
plater_integration_frame.DamageTaken = {}

--> aprox. 6 updates per second
local CONST_REALTIME_UPDATE_TIME = 0.166
--> how many samples to store, 30 x .166 aprox 5 seconds buffer
local CONST_BUFFER_SIZE = 30
--> Dps division factor
PLATER_DPS_SAMPLE_SIZE = CONST_BUFFER_SIZE * CONST_REALTIME_UPDATE_TIME

--> separate CLEU events from the Tick event for performance
plater_integration_frame.OnTickFrame = CreateFrame ("frame", "DetailsPlaterFrameOnTicker", UIParent)

--> on tick function
plater_integration_frame.OnTickFrameFunc = function (self, deltaTime)
	if (self.NextUpdate < 0) then
		for targetGUID, damageTable in pairs (plater_integration_frame.DamageTaken) do
		
			--> total damage
			local totalDamage = damageTable.TotalDamageTaken
			local totalDamageFromPlayer = damageTable.TotalDamageTakenFromPlayer
			
			--> damage on this update
			local damageOnThisUpdate = totalDamage - damageTable.LastTotalDamageTaken
			local damageOnThisUpdateFromPlayer = totalDamageFromPlayer - damageTable.LastTotalDamageTakenFromPlayer
			
			--> update the last damage taken
			damageTable.LastTotalDamageTaken = totalDamage
			damageTable.LastTotalDamageTakenFromPlayer = totalDamageFromPlayer
			
			--> sum the current damage 
			damageTable.CurrentDamage = damageTable.CurrentDamage + damageOnThisUpdate
			damageTable.CurrentDamageFromPlayer = damageTable.CurrentDamageFromPlayer + damageOnThisUpdateFromPlayer
			
			--> add to the buffer the damage added
			tinsert (damageTable.RealTimeBuffer, 1, damageOnThisUpdate)
			tinsert (damageTable.RealTimeBufferFromPlayer, 1, damageOnThisUpdateFromPlayer)
			
			--> remove the damage from the buffer
			local damageRemoved = tremove (damageTable.RealTimeBuffer, CONST_BUFFER_SIZE + 1)
			if (damageRemoved) then
				damageTable.CurrentDamage = max (damageTable.CurrentDamage - damageRemoved, 0)
			end
			
			local damageRemovedFromPlayer = tremove (damageTable.RealTimeBufferFromPlayer, CONST_BUFFER_SIZE + 1)
			if (damageRemovedFromPlayer) then
				damageTable.CurrentDamageFromPlayer = max (damageTable.CurrentDamageFromPlayer - damageRemovedFromPlayer, 0)
			end
		end
		
		--update time
		self.NextUpdate = CONST_REALTIME_UPDATE_TIME
	else
		self.NextUpdate = self.NextUpdate - deltaTime
	end
end


--> parse the damage taken by unit
function plater_integration_frame.AddDamageToGUID (sourceGUID, targetGUID, time, amount)
	local damageTable = plater_integration_frame.DamageTaken [targetGUID]
	
	if (not damageTable) then
		plater_integration_frame.DamageTaken [targetGUID] = {
			LastEvent = time,
			
			TotalDamageTaken = amount,
			TotalDamageTakenFromPlayer = 0,
			
			--for real time
				RealTimeBuffer = {},
				RealTimeBufferFromPlayer = {},
				LastTotalDamageTaken = 0,
				LastTotalDamageTakenFromPlayer = 0,
				CurrentDamage = 0,
				CurrentDamageFromPlayer = 0,
		}
		
		--> is the damage from the player it self?
		if (sourceGUID == plater_integration_frame.PlayerGUID) then
			plater_integration_frame.DamageTaken [targetGUID].TotalDamageTakenFromPlayer = amount
		end
	else
		damageTable.LastEvent = time
		damageTable.TotalDamageTaken = damageTable.TotalDamageTaken + amount
		
		if (sourceGUID == plater_integration_frame.PlayerGUID) then
			damageTable.TotalDamageTakenFromPlayer = damageTable.TotalDamageTakenFromPlayer + amount
		end
	end
end

plater_integration_frame:SetScript ("OnEvent", function (self)
	local time, token, hidding, sourceGUID, sourceName, sourceFlag, sourceFlag2, targetGUID, targetName, targetFlag, targetFlag2, spellID, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical = CombatLogGetCurrentEventInfo()
	
	--> tamage taken by the GUID unit
	if (token == "SPELL_DAMAGE" or token == "SPELL_PERIODIC_DAMAGE" or token == "RANGE_DAMAGE" or token == "DAMAGE_SHIELD") then
		plater_integration_frame.AddDamageToGUID (sourceGUID, targetGUID, time, amount)
		
	elseif (token == "SWING_DAMAGE") then
		--the damage is passed in the spellID argument position
		plater_integration_frame.AddDamageToGUID (sourceGUID, targetGUID, time, spellID)
	end
end)

function Details:RefreshPlaterIntegration()

	if (Plater and Details.plater.realtime_dps_enabled or Details.plater.realtime_dps_player_enabled or Details.plater.damage_taken_enabled) then
		
		--> wipe the cache
		wipe (plater_integration_frame.DamageTaken)
		
		--> read cleu events
		plater_integration_frame:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
		
		--> start the real time dps updater
		plater_integration_frame.OnTickFrame.NextUpdate = CONST_REALTIME_UPDATE_TIME
		plater_integration_frame.OnTickFrame:SetScript ("OnUpdate", plater_integration_frame.OnTickFrameFunc)

		--> cache the player serial
		plater_integration_frame.PlayerGUID = UnitGUID ("player")
		
		--> cancel the timer if already have one
		if (plater_integration_frame.CleanUpTimer and not plater_integration_frame.CleanUpTimer._cancelled) then
			plater_integration_frame.CleanUpTimer:Cancel()
		end
		
		--> cleanup the old tables
		plater_integration_frame.CleanUpTimer = C_Timer.NewTicker (10, function()
			local now = time()
			for GUID, damageTable in pairs (plater_integration_frame.DamageTaken) do
				if (damageTable.LastEvent + 9.9 < now) then
					plater_integration_frame.DamageTaken [GUID] = nil
				end
			end
		end)
		
	else
		--> unregister the cleu
		plater_integration_frame:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
		
		--> stop the real time updater
		plater_integration_frame.OnTickFrame:SetScript ("OnUpdate", nil)
		
		--> stop the cleanup process
		if (plater_integration_frame.CleanUpTimer and not plater_integration_frame.CleanUpTimer._cancelled) then
			plater_integration_frame.CleanUpTimer:Cancel()
		end
	end
	
	
	
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> general macros

function _detalhes:OpenPlayerDetails (window)
	
	window = window or 1
	
	local instance = _detalhes:GetInstance (window)
	if (instance) then
		local display, subDisplay = instance:GetDisplay()
		if (display == 1) then
			instance:AbreJanelaInfo (Details:GetPlayer (false, 1))
		elseif (display == 2) then
			instance:AbreJanelaInfo (Details:GetPlayer (false, 2))
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> extra buttons at the death options (release, death recap)

local detailsOnDeathMenu = CreateFrame ("frame", "DetailsOnDeathMenu", UIParent)
detailsOnDeathMenu:SetHeight (30)
detailsOnDeathMenu.Debug = false

detailsOnDeathMenu:RegisterEvent ("PLAYER_REGEN_ENABLED")
detailsOnDeathMenu:RegisterEvent ("ENCOUNTER_END")
DetailsFramework:ApplyStandardBackdrop (detailsOnDeathMenu)
detailsOnDeathMenu:SetAlpha (0.75)

--disable text
detailsOnDeathMenu.disableLabel = _detalhes.gump:CreateLabel (detailsOnDeathMenu, "you can disable this at /details > Raid Tools", 9)

detailsOnDeathMenu.warningLabel = _detalhes.gump:CreateLabel (detailsOnDeathMenu, "", 11)
detailsOnDeathMenu.warningLabel.textcolor = "red"
detailsOnDeathMenu.warningLabel:SetPoint ("bottomleft", detailsOnDeathMenu, "bottomleft", 5, 2)
detailsOnDeathMenu.warningLabel:Hide()

detailsOnDeathMenu:SetScript ("OnEvent", function (self, event, ...)
	if (event == "ENCOUNTER_END") then --event == "PLAYER_REGEN_ENABLED" or 
		C_Timer.After (0.5, detailsOnDeathMenu.ShowPanel)
	end
end)

function detailsOnDeathMenu.OpenEncounterBreakdown()
	if (not _detalhes:GetPlugin ("DETAILS_PLUGIN_ENCOUNTER_DETAILS")) then
		detailsOnDeathMenu.warningLabel.text = "Encounter Breakdown plugin is disabled! Please enable it in the Addon Control Panel."
		detailsOnDeathMenu.warningLabel:Show()
		C_Timer.After (5, function()
			detailsOnDeathMenu.warningLabel:Hide()
		end)
	end

	Details:OpenPlugin ("Encounter Breakdown")
	
	GameCooltip2:Hide()
end

function detailsOnDeathMenu.OpenPlayerEndurance()
	if (not _detalhes:GetPlugin ("DETAILS_PLUGIN_DEATH_GRAPHICS")) then
		detailsOnDeathMenu.warningLabel.text = "Advanced Death Logs plugin is disabled! Please enable it (or download) in the Addon Control Panel."
		detailsOnDeathMenu.warningLabel:Show()
		C_Timer.After (5, function()
			detailsOnDeathMenu.warningLabel:Hide()
		end)
	end

	DetailsPluginContainerWindow.OnMenuClick (nil, nil, "DETAILS_PLUGIN_DEATH_GRAPHICS", true)
	
	C_Timer.After (0, function()
		local a = Details_DeathGraphsModeEnduranceButton and Details_DeathGraphsModeEnduranceButton.MyObject:Click()
	end)
	
	GameCooltip2:Hide()
end

function detailsOnDeathMenu.OpenPlayerSpells()
	
	local window1 = Details:GetWindow (1)
	local window2 = Details:GetWindow (2)
	local window3 = Details:GetWindow (3)
	local window4 = Details:GetWindow (4)
	
	local assignedRole = UnitGroupRolesAssigned ("player")
	if (assignedRole == "HEALER") then
		if (window1 and window1:GetDisplay() == 2) then
			Details:OpenPlayerDetails(1)
			
		elseif (window2 and window2:GetDisplay() == 2) then
			Details:OpenPlayerDetails(2)
			
		elseif (window3 and window3:GetDisplay() == 2) then
			Details:OpenPlayerDetails(3)
			
		elseif (window4 and window4:GetDisplay() == 2) then
			Details:OpenPlayerDetails(4)
			
		else
			Details:OpenPlayerDetails (1)
		end
	else
		if (window1 and window1:GetDisplay() == 1) then
			Details:OpenPlayerDetails(1)
			
		elseif (window2 and window2:GetDisplay() == 1) then
			Details:OpenPlayerDetails(2)
			
		elseif (window3 and window3:GetDisplay() == 1) then
			Details:OpenPlayerDetails(3)
			
		elseif (window4 and window4:GetDisplay() == 1) then
			Details:OpenPlayerDetails(4)
			
		else
			Details:OpenPlayerDetails (1)
		end
	end
	
	GameCooltip2:Hide()
end

--encounter breakdown button
detailsOnDeathMenu.breakdownButton = _detalhes.gump:CreateButton (detailsOnDeathMenu, detailsOnDeathMenu.OpenEncounterBreakdown, 120, 20, "Encounter Breakdown", "breakdownButton")
detailsOnDeathMenu.breakdownButton:SetTemplate (_detalhes.gump:GetTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE"))
detailsOnDeathMenu.breakdownButton:SetPoint ("topleft", detailsOnDeathMenu, "topleft", 5, -5)
detailsOnDeathMenu.breakdownButton:Hide()

detailsOnDeathMenu.breakdownButton.CoolTip = {
	Type = "tooltip",
	BuildFunc = function()
		GameCooltip2:Preset (2)
		GameCooltip2:AddLine ("Show a panel with:")
		GameCooltip2:AddLine ("- Player Damage Taken")
		GameCooltip2:AddLine ("- Damage Taken by Spell")
		GameCooltip2:AddLine ("- Enemy Damage Taken")
		GameCooltip2:AddLine ("- Player Deaths")
		GameCooltip2:AddLine ("- Interrupts and Dispells")
		GameCooltip2:AddLine ("- Damage Done Chart")
		GameCooltip2:AddLine ("- Damage Per Phase")
		GameCooltip2:AddLine ("- Weakauras Tool")
		
		if (not _detalhes:GetPlugin ("DETAILS_PLUGIN_ENCOUNTER_DETAILS")) then
			GameCooltip2:AddLine ("Encounter Breakdown plugin is disabled in the Addon Control Panel.", "", 1, "red")
		end
		
	end, --> called when user mouse over the frame
	OnEnterFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = true
	end,
	OnLeaveFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = false
	end,
	FixedValue = "none",
	ShowSpeed = .5,
	Options = function()
		GameCooltip:SetOption ("MyAnchor", "top")
		GameCooltip:SetOption ("RelativeAnchor", "bottom")
		GameCooltip:SetOption ("WidthAnchorMod", 0)
		GameCooltip:SetOption ("HeightAnchorMod", -13)
		GameCooltip:SetOption ("TextSize", 10)
		GameCooltip:SetOption ("FixedWidth", 220)
	end
}
GameCooltip2:CoolTipInject (detailsOnDeathMenu.breakdownButton)

--player endurance button
detailsOnDeathMenu.enduranceButton = _detalhes.gump:CreateButton (detailsOnDeathMenu, detailsOnDeathMenu.OpenPlayerEndurance, 120, 20, "Player Endurance", "enduranceButton")
detailsOnDeathMenu.enduranceButton:SetTemplate (_detalhes.gump:GetTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE"))
detailsOnDeathMenu.enduranceButton:SetPoint ("topleft", detailsOnDeathMenu.breakdownButton, "topright", 2, 0)
detailsOnDeathMenu.enduranceButton:Hide()

detailsOnDeathMenu.enduranceButton.CoolTip = {
	Type = "tooltip",
	BuildFunc = function()
		GameCooltip2:Preset (2)
		GameCooltip2:AddLine ("Open Player Endurance Breakdown")
		GameCooltip2:AddLine ("")
		GameCooltip2:AddLine ("Player endurance is calculated using the amount of player deaths.")
		GameCooltip2:AddLine ("By default the plugin register the three first player deaths on each encounter to calculate who is under performing.")
		
		--GameCooltip2:AddLine (" ")
		
		if (not _detalhes:GetPlugin ("DETAILS_PLUGIN_DEATH_GRAPHICS")) then
			GameCooltip2:AddLine ("Advanced Death Logs plugin is disabled or not installed, check the Addon Control Panel or download it from the Twitch APP.", "", 1, "red")
		end

	end, --> called when user mouse over the frame
	OnEnterFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = true
	end,
	OnLeaveFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = false
	end,
	FixedValue = "none",
	ShowSpeed = .5,
	Options = function()
		GameCooltip:SetOption ("MyAnchor", "top")
		GameCooltip:SetOption ("RelativeAnchor", "bottom")
		GameCooltip:SetOption ("WidthAnchorMod", 0)
		GameCooltip:SetOption ("HeightAnchorMod", -13)
		GameCooltip:SetOption ("TextSize", 10)
		GameCooltip:SetOption ("FixedWidth", 220)
	end
}
GameCooltip2:CoolTipInject (detailsOnDeathMenu.enduranceButton)

--spells
detailsOnDeathMenu.spellsButton = _detalhes.gump:CreateButton (detailsOnDeathMenu, detailsOnDeathMenu.OpenPlayerSpells, 48, 20, "Spells", "SpellsButton")
detailsOnDeathMenu.spellsButton:SetTemplate (_detalhes.gump:GetTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE"))
detailsOnDeathMenu.spellsButton:SetPoint ("topleft", detailsOnDeathMenu.enduranceButton, "topright", 2, 0)
detailsOnDeathMenu.spellsButton:Hide()

detailsOnDeathMenu.spellsButton.CoolTip = {
	Type = "tooltip",
	BuildFunc = function()
		GameCooltip2:Preset (2)
		GameCooltip2:AddLine ("Open your player Details! breakdown.")
		
	end, --> called when user mouse over the frame
	OnEnterFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = true
	end,
	OnLeaveFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = false
	end,
	FixedValue = "none",
	ShowSpeed = .5,
	Options = function()
		GameCooltip:SetOption ("MyAnchor", "top")
		GameCooltip:SetOption ("RelativeAnchor", "bottom")
		GameCooltip:SetOption ("WidthAnchorMod", 0)
		GameCooltip:SetOption ("HeightAnchorMod", -13)
		GameCooltip:SetOption ("TextSize", 10)
		GameCooltip:SetOption ("FixedWidth", 220)
	end
}
GameCooltip2:CoolTipInject (detailsOnDeathMenu.spellsButton)

function detailsOnDeathMenu.CanShowPanel()
	if (StaticPopup_Visible ("DEATH")) then
		if (not _detalhes.on_death_menu) then
			return
		end

		if (detailsOnDeathMenu.Debug) then
			return true
		end
		
		--> check if the player just wiped in an encounter
		if (IsInRaid()) then
			local isInInstance = IsInInstance()
			if (isInInstance) then
				--> check if all players in the raid are out of combat
				for i = 1, GetNumGroupMembers() do
					if (UnitAffectingCombat ("raid" .. i)) then
						C_Timer.After (0.5, detailsOnDeathMenu.ShowPanel)
						return false
					end
				end
				
				if (_detalhes.in_combat) then
					C_Timer.After (0.5, detailsOnDeathMenu.ShowPanel)
					return false
				end
				
				return true
			end
		end
	end
end

function detailsOnDeathMenu.ShowPanel()
	if (not detailsOnDeathMenu.CanShowPanel()) then
		return
	end
	
	if (ElvUI) then
		detailsOnDeathMenu:SetPoint ("topleft", StaticPopup1, "bottomleft", 0, -1)
		detailsOnDeathMenu:SetPoint ("topright", StaticPopup1, "bottomright", 0, -1)
	else
		detailsOnDeathMenu:SetPoint ("topleft", StaticPopup1, "bottomleft", 4, 2)
		detailsOnDeathMenu:SetPoint ("topright", StaticPopup1, "bottomright", -4, 2)
	end
	
	detailsOnDeathMenu.breakdownButton:Show()
	detailsOnDeathMenu.enduranceButton:Show()
	detailsOnDeathMenu.spellsButton:Show()
	
	detailsOnDeathMenu:Show()
	
	detailsOnDeathMenu:SetHeight (30)
	
	if (not _detalhes:GetTutorialCVar ("DISABLE_ONDEATH_PANEL")) then
		detailsOnDeathMenu.disableLabel:Show()
		detailsOnDeathMenu.disableLabel:SetPoint ("bottomleft", detailsOnDeathMenu, "bottomleft", 5, 1)
		detailsOnDeathMenu.disableLabel.color = "gray"
		detailsOnDeathMenu.disableLabel.alpha = 0.5
		detailsOnDeathMenu:SetHeight (detailsOnDeathMenu:GetHeight() + 10)
		
		if (math.random (1, 3) == 3) then
			_detalhes:SetTutorialCVar ("DISABLE_ONDEATH_PANEL", true)
		end
	end
end

hooksecurefunc ("StaticPopup_Show", function (which, text_arg1, text_arg2, data, insertedFrame)
	--print (which, text_arg1, text_arg2, data, insertedFrame)
	--print ("popup Show:", which)
	if (which == "DEATH") then
		--StaticPopup1
		if (detailsOnDeathMenu.Debug) then
			C_Timer.After (0.5, detailsOnDeathMenu.ShowPanel)
		end
	end
end)

hooksecurefunc ("StaticPopup_Hide", function (which, data)
--	if (which and which:find ("EQUIP")) then
--		return
--	end
	
	--print ("popup Hide:", which)
	
	if (which == "DEATH") then
		detailsOnDeathMenu:Hide()
	end
end)



--endd
