local addonName, Data = ...
local GetAddOnMetadata = GetAddOnMetadata

local L = Data.L
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local LSM = LibStub("LibSharedMedia-3.0")


local CTimerNewTicker = C_Timer.NewTicker


local function copy(obj)
	if type(obj) ~= 'table' then return obj end
	local res = {}
	for k, v in pairs(obj) do res[copy(k)] = copy(v) end
	return res
end
						
local function addStaticPopupForPlayerTypeConfigImport(playerType, oppositePlayerType)
	StaticPopupDialogs["CONFIRM_OVERRITE_"..addonName..playerType] = {
	  text = L.ConfirmProfileOverride:format(L[playerType], L[oppositePlayerType]),
	  button1 = YES,
	  button2 = NO,
	  OnAccept = function (self) 
			BattleGroundEnemies.db.profile[playerType] = copy(BattleGroundEnemies.db.profile[oppositePlayerType])
			BattleGroundEnemies:ProfileChanged()
			AceConfigRegistry:NotifyChange("BattleGroundEnemies")
	  end,
	  OnCancel = function (self) end,
	  OnHide = function (self) self.data = nil; self.selectedIcon = nil; end,
	  hideOnEscape = 1,
	  timeout = 30,
	  exclusive = 1,
	  whileDead = 1,
	}
end
addStaticPopupForPlayerTypeConfigImport("Enemies", "Allies")
addStaticPopupForPlayerTypeConfigImport("Allies", "Enemies")


local function addStaticPopupBGTypeConfigImport(playerType, oppositePlayerType, BGSize)
	StaticPopupDialogs["CONFIRM_OVERRITE_"..addonName..playerType..BGSize] = {
	  text = L.ConfirmProfileOverride:format(L[playerType]..": "..L["BGSize_"..BGSize], L[oppositePlayerType]..": "..L["BGSize_"..BGSize]),
	  button1 = YES,
	  button2 = NO,
	  OnAccept = function (self) 
			BattleGroundEnemies.db.profile[playerType][BGSize] = copy(BattleGroundEnemies.db.profile[oppositePlayerType][BGSize])
			if BattleGroundEnemies.BGSize and BattleGroundEnemies.BGSize == tonumber(BGSize) then BattleGroundEnemies[playerType]:ApplyBGSizeSettings() end
			AceConfigRegistry:NotifyChange("BattleGroundEnemies")
	  end,
	  OnCancel = function (self) end,
	  OnHide = function (self) self.data = nil; self.selectedIcon = nil; end,
	  hideOnEscape = 1,
	  timeout = 30,
	  exclusive = 1,
	  whileDead = 1,
	}
end
addStaticPopupBGTypeConfigImport("Enemies", "Allies", "15")
addStaticPopupBGTypeConfigImport("Allies", "Enemies", "15")
addStaticPopupBGTypeConfigImport("Enemies", "Allies", "40")
addStaticPopupBGTypeConfigImport("Allies", "Enemies", "40")



local function getOption(location, option)
	local value = location[option[#option]]

	if type(value) == "table" then
		--BattleGroundEnemies:Debug("is table")
		return unpack(value)
	else
		return value
	end
end

local timer = nil
local function ApplyAllSettings()
	if timer then timer:Cancel() end -- use a timer to apply changes after 0.2 second, this prevents the UI from getting laggy when the user uses a slider option
	timer = CTimerNewTicker(0.2, function() 
		BattleGroundEnemies.Enemies:ApplyAllSettings()
		BattleGroundEnemies.Allies:ApplyAllSettings()
		timer = nil
	end, 1)
end



local function setOption(location, option, ...)


	

	local value
	if option.type == "color" then
		value = {...}   -- local r, g, b, alpha = ...
	else
		value = ...
	end

	location[option[#option]] = value
	ApplyAllSettings()
	

	--BattleGroundEnemies.db.profile[key] = value
end


local function addVerticalSpacing(order)
	local verticalSpacing = {
		type = "description",
		name = " ",
		fontSize = "large",
		width = "full",
		order = order
	}
	return verticalSpacing
end

local function addHorizontalSpacing(order)
	local horizontalSpacing = {
		type = "description",
		name = " ",
		width = "half",	
		order = order,
	}
	return horizontalSpacing
end


local function addIconPositionSettings(location, optionname)
	local size = optionname.."_Size"
	local horizontalDirection = optionname.."_HorizontalGrowDirection"
	local horizontalSpacing	= optionname.."_HorizontalSpacing"
	local verticalDirection = optionname.."_VerticalGrowdirection"
	local verticalSpacing =	optionname.."_VerticalSpacing"
	local iconsPerRow = optionname.."_IconsPerRow"
	
	local options = {
		[size] = {
			type = "range",
			name = L.Size,
			min = 0,
			max = 40,
			step = 1,
			order = 1
		},
		[iconsPerRow] = {
			type = "range",
			name = L.IconsPerRow,
			min = 4,
			max = 30,
			step = 1,
			order = 2
		},
		Fake = addVerticalSpacing(3),
		[horizontalDirection] = {
			type = "select",
			name = L.HorizontalGrowdirection,
			width = "normal",
			values = Data.HorizontalDirections,
			order = 4
		},
		[horizontalSpacing] = {
			type = "range",
			name = L.HorizontalSpacing,
			min = 0,
			max = 20,
			step = 1,
			order = 5
		},
		Fake1 = addVerticalSpacing(6),
		[verticalDirection] = {
			type = "select",
			name = L.VerticalGrowdirection,
			width = "half",
			values = Data.VerticalDirections,
			order = 7
		},
		[verticalSpacing] = {
			type = "range",
			name = L.VerticalSpacing,
			min = 0,
			max = 20,
			step = 1,
			order = 8
		}
	}
	return options
end


-- all positions, corners, middle, left etc.
local function addContainerPositionSettings(location, optionname)
	local point = optionname.."_Point"
	local relativeTo = optionname.."_RelativeTo"
	local relativePoint = optionname.."_RelativePoint"
	local ofsx = optionname.."_OffsetX"
	local ofsy = optionname.."_OffsetY"
	
	local options = {
		[point] = {
			type = "select",
			name = L.Point,
			width = "normal",
			values = Data.AllPositions,
			order = 1
		},
		[relativeTo] = {
			type = "select",
			name = L.AttachToObject,
			desc = L.AttachToObject_Desc,
			values = Data.Frames,
			order = 2
		},
		Fake = addVerticalSpacing(3),
		[relativePoint] = {
			type = "select",
			name = L.PointAtObject,
			width = "half",
			values = Data.AllPositions,
			order = 4
		},
		[ofsx] = {
			type = "range",
			name = L.OffsetX,
			min = -20,
			max = 20,
			step = 1,
			order = 5
		},
		[ofsy] = {
			type = "range",
			name = L.OffsetY,
			min = -20,
			max = 20,
			step = 1,
			order = 6
		}
	}
	return options
end

-- sets 2 points, user can choose left and right, 1 point at TOP..setting, and another point BOTTOM..setting is set
local function addBasicPositionSettings(location, optionname)
	local point = optionname.."_BasicPoint"
	local relativeTo = optionname.."_RelativeTo"
	local relativePoint = optionname.."_RelativePoint"
	local ofsx = optionname.."_OffsetX"
	local ofsy = optionname.."_OffsetY"
	
	local options = {
		[point] = {
			type = "select",
			name = L.Side,
			width = "normal",
			values = Data.BasicPositions,
			order = 1
		},
		[relativeTo] = {
			type = "select",
			name = L.AttachToObject,
			desc = L.AttachToObject_Desc,
			values = Data.Frames,
			order = 2
		},
		Fake = addVerticalSpacing(3),
		[relativePoint] = {
			type = "select",
			name = L.SideAtObject,
			width = "half",
			values = Data.BasicPositions,
			order = 4
		},
		[ofsx] = {
			type = "range",
			name = L.OffsetX,
			min = -20,
			max = 20,
			step = 1,
			order = 5
		}
	}
	return options
end

local function addNormalTextSettings(location, optionname)
	local fontsize = optionname.."_Fontsize"
	local textcolor = optionname.."_Textcolor"
	local outline = optionname.."_Outline"
	local enableTextShadow = optionname.."_EnableTextshadow"
	local textShadowcolor = optionname.."_TextShadowcolor"
		
	local options = {
		[fontsize] = {
			type = "range",
			name = L.Fontsize,
			desc = L["Fontsize_Desc"],
			min = 1,
			max = 40,
			step = 1,
			width = "normal",
			order = 1
		},
		[outline] = {
			type = "select",
			name = L.Font_Outline,
			desc = L.Font_Outline_Desc,
			values = Data.FontOutlines,
			order = 2
		},
		Fake = addVerticalSpacing(3),
		[textcolor] = {
			type = "color",
			name = L.Fontcolor,
			desc = L["Fontcolor_Desc"],
			hasAlpha = true,
			width = "half",
			order = 4
		},
		[enableTextShadow] = {
			type = "toggle",
			name = L.FontShadow_Enabled,
			desc = L.FontShadow_Enabled_Desc,
			order = 5
		},
		[textShadowcolor] = {
			type = "color",
			name = L.FontShadowColor,
			desc = L.FontShadowColor_Desc,
			disabled = function() 
				return not location[enableTextShadow]
			end,
			hasAlpha = true,
			order = 6
		}
	}
	return options
end


local function addCooldownTextsettings(location, optionname)
	local showNumbers = optionname.."_ShowNumbers"
	local fontsize = optionname.."_Cooldown_Fontsize"
	local outline = optionname.."_Cooldown_Outline"
	local enableTextShadow = optionname.."_Cooldown_EnableTextshadow"
	local textShadowcolor = optionname.."_Cooldown_TextShadowcolor"	

	local options = {
		[showNumbers] = {
			type = "toggle",
			name = L.ShowNumbers,
			desc = L["ShowNumbers_Desc"],
			order = 1
		},
		asdfasdf = {
			type = "group",
			name = "",
			desc = "",
			disabled = function() 
				return not location[showNumbers]
			end, 
			inline = true,
			order = 2,
			args = {
				[fontsize] = {
					type = "range",
					name = L.Fontsize,
					desc = L.Fontsize_Desc,
					min = 6,
					max = 40,
					step = 1,
					width = "normal",
					order = 3
				},
				[outline] = {
					type = "select",
					name = L.Font_Outline,
					desc = L.Font_Outline_Desc,
					values = Data.FontOutlines,
					order = 4
				},
				Fake1 = addVerticalSpacing(5),
				[enableTextShadow] = {
					type = "toggle",
					name = L.FontShadow_Enabled,
					desc = L.FontShadow_Enabled_Desc,
					order = 6
				},
				[textShadowcolor] = {
					type = "color",
					name = L.FontShadowColor,
					desc = L.FontShadowColor_Desc,
					disabled = function()
						return not location[enableTextShadow] 
					end, 
					hasAlpha = true,
					order = 7
				}
			}
		}
	}
	return options
end

local function addEnemyAndAllySettings(self)
	local playerType = self.PlayerType
	local oppositePlayerType = playerType == "Enemies" and "Allies" or "Enemies"
	local settings = {}
	local location = BattleGroundEnemies.db.profile[playerType]

	
	settings.GeneralSettings = {
		type = "group",
		name = GENERAL,
		desc = L["GeneralSettings"..playerType],
		get =  function(option)
			return getOption(location, option)
		end,
		set = function(option, ...) 
			return setOption(location, option, ...)
		end,
		--childGroups = "tab",
		order = 1,
		args = {
			Enabled = {
				type = "toggle",
				name = ENABLE,
				desc = "test",
				order = 1
			},
			Fake = addHorizontalSpacing(2),
			Fake1 = addHorizontalSpacing(3),
			Fake2 = addHorizontalSpacing(4),
			CopySettings = {
				type = "execute",
				name = L.CopySettings:format(L[oppositePlayerType]),
				desc = L.CopySettings_Desc:format(L[oppositePlayerType])..L.NotAvailableInCombat,
				disabled = InCombatLockdown,
				func = function()
					StaticPopup_Show("CONFIRM_OVERRITE_"..addonName..playerType)
				end,
				width = "double",
				order = 5
			},
			RangeIndicator_Settings = {
				type = "group",
				name = L.RangeIndicator_Settings,
				desc = L.RangeIndicator_Settings_Desc,
				order = 6,
				args = {
					RangeIndicator_Enabled = {
						type = "toggle",
						name = L.RangeIndicator_Enabled,
						desc = L.RangeIndicator_Enabled_Desc,
						order = 1
					},
					RangeIndicator_Range = {
						type = "select",
						name = L.RangeIndicator_Range,
						desc = L.RangeIndicator_Range_Desc,
						disabled = function() return not location.RangeIndicator_Enabled end,
						get = function() return Data[playerType.."ItemIDToRange"][location.RangeIndicator_Range] end,
						set = function(option, value)
							value = Data[playerType.."RangeToItemID"][value]
							return setOption(location, option, value)
						end,
						values = Data[playerType.."RangeToRange"],
						width = "half",
						order = 2
					},
					RangeIndicator_Alpha = {
						type = "range",
						name = L.RangeIndicator_Alpha,
						desc = L.RangeIndicator_Alpha_Desc,
						disabled = function() return not location.RangeIndicator_Enabled end,
						min = 0,
						max = 1,
						step = 0.05,
						order = 3
					},
					Fake = addVerticalSpacing(4),
					RangeIndicator_Everything = {
						type = "toggle",
						name = L.RangeIndicator_Everything,
						disabled = function() return not location.RangeIndicator_Enabled end,
						order = 6
					},
					RangeIndicator_Frames = {
						type = "multiselect",
						name = L.RangeIndicator_Frames,
						desc = L.RangeIndicator_Frames_Desc,
						hidden = function() return (not location.RangeIndicator_Enabled or location.RangeIndicator_Everything) end,
						get = function(option, key)
							return location.RangeIndicator_Frames[key]
						end,
						set = function(option, key, state) 
							location.RangeIndicator_Frames[key] = state
							ApplyAllSettings()
						end,
						width = "double",
						values = Data.RangeFrames,
						order = 7
					}
				}
			},
			Name = {
				type = "group",
				name = L.Name,
				desc = L.Name_Desc,
				order = 7,
				args = {
					ConvertCyrillic = {
						type = "toggle",
						name = L.ConvertCyrillic,
						desc = L.ConvertCyrillic_Desc,
						width = "normal",
						order = 1
					},
					ShowRealmnames = {
						type = "toggle",
						name = L.ShowRealmnames,
						desc = L.ShowRealmnames_Desc,
						width = "normal",
						order = 2
					},
					Fake = addVerticalSpacing(3),
					LevelTextSettings = {
						type = "group",
						name = L.LevelTextSettings,
						inline = true,
						order = 4,
						args = {
							LevelText_Enabled = {
								type = "toggle",
								name = L.LevelText_Enabled,
								order = 1
							},
							LevelText_OnlyShowIfNotMaxLevel = {
								type = "toggle",
								name = L.LevelText_OnlyShowIfNotMaxLevel,
								disabled = function() return not location.LevelText_Enabled end,
								order = 2
							},
							LevelTextTextSettings = {
								type = "group",
								name = "",
								--desc = L.TrinketSettings_Desc,
								disabled = function() return not location.LevelText_Enabled end,
								inline = true,
								order = 3,
								args = addNormalTextSettings(location, "LevelText")
							}
						}
					}
				}
			},
			KeybindSettings = {
				type = "group",
				name = KEY_BINDINGS,
				desc = L.KeybindSettings_Desc..L.NotAvailableInCombat,
				disabled = InCombatLockdown,
				--childGroups = "tab",
				order = 9,
				args = {
					UseClique = {
						type = "toggle",
						name = L.EnableClique,
						desc = L.EnableClique_Desc,
						order = 1,
						hidden = playerType == "Enemies"
					},
					LeftButton = {
						type = "group",
						name = KEY_BUTTON1,
						order = 2,
						disabled = function() return location.UseClique end,
						args = {
							LeftButtonType = {
								type = "select",
								name = KEY_BUTTON1,
								values = Data.Buttons,
								order = 1
							},
							LeftButtonValue = {
								type = "input",
								name = ENTER_MACRO_LABEL,
								desc = L.CustomMacro_Desc,
								disabled = function() return location.LeftButtonType == "Target" or location.LeftButtonType == "Focus" end,
								multiline = true,
								width = 'double',
								order = 2
							},

						}
					},
					RightButton = {
						type = "group",
						name = KEY_BUTTON2,
						order = 3,
						disabled = function() return location.UseClique end,
						args = {
							RightButtonType = {
								type = "select",
								name = KEY_BUTTON2,
								values = Data.Buttons,
								order = 1
							},
							RightButtonValue = {
								type = "input",
								name = ENTER_MACRO_LABEL,
								desc = L.CustomMacro_Desc,
								disabled = function() return location.RightButtonType == "Target" or location.RightButtonType == "Focus" end,
								multiline = true,
								width = 'double',
								order = 2
							},

						}
					},
					MiddleButton = {
						type = "group",
						name = KEY_BUTTON3,
						order = 4,
						disabled = function() return location.UseClique end,
						args = {

							MiddleButtonType = {
								type = "select",
								name = KEY_BUTTON3,
								values = Data.Buttons,
								order = 1
							},
							MiddleButtonValue = {
								type = "input",
								name = ENTER_MACRO_LABEL,
								desc = L.CustomMacro_Desc,
								disabled = function() return location.MiddleButtonType == "Target" or location.MiddleButtonType == "Focus" end,
								multiline = true,
								width = 'double',
								order = 2
							}
						}
					}
				
				}
			}
		}
	}
	

	for k, BGSize in pairs({"15", "40"}) do
		local location = BattleGroundEnemies.db.profile[playerType][BGSize]
		settings[BGSize] = {
			type = "group", 
			name = L["BGSize_"..BGSize],
			desc = L["BGSize_"..BGSize.."_Desc"]:format(L[playerType]),
			disabled = function() return not self.config.Enabled end,
			get =  function(option)
				return getOption(location, option)
			end,
			set = function(option, ...)
				return setOption(location, option, ...)
			end,
			order = k + 1, 
			args = {
				Enabled = {
					type = "toggle",
					name = ENABLE,
					desc = "test",
					order = 1
				},
				Fake = addHorizontalSpacing(2),
				CopySettings = {
					type = "execute",
					name = L.CopySettings:format(L[oppositePlayerType]..": "..L["BGSize_"..BGSize]),
					desc = L.CopySettings_Desc:format(L[oppositePlayerType]..": "..L["BGSize_"..BGSize]),
					func = function()
						StaticPopup_Show("CONFIRM_OVERRITE_"..addonName..playerType..BGSize)
					end,
					width = "double",
					order = 3
				},
				MainFrameSettings = {
					type = "group",
					name = L.MainFrameSettings,
					desc = L.MainFrameSettings_Desc:format(L[playerType == "Enemies" and "enemies" or "allies"]),
					disabled = function() return not location.Enabled end,
					--childGroups = "tab",
					order = 4,
					args = {
						Framescale = {
							type = "range",
							name = L.Framescale,
							desc = L.Framescale_Desc..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							min = 0.3,
							max = 2,
							step = 0.05,
							order = 1
						},
						PlayerCount = {
							type = "group",
							name = L.PlayerCount_Enabled,
							order = 2,
							inline = true,
							args = {
								PlayerCount_Enabled = {
									type = "toggle",
									name = L.PlayerCount_Enabled,
									desc = L.PlayerCount_Enabled_Desc,
									order = 1
								},
								PlayerCountTextSettings = {
									type = "group",
									name = "",
									--desc = L.TrinketSettings_Desc,
									disabled = function() return not location.PlayerCount_Enabled end,
									inline = true,
									order = 2,
									args = addNormalTextSettings(location, "PlayerCount")
								}
							}
						}
					}
				},
				BarSettings = {
					type = "group",
					name = L.BarSettings,
					desc = L.BarSettings_Desc,
					disabled = function() return not location.Enabled end,
					--childGroups = "tab",
					order = 5,
					args = {
						BarWidth = {
							type = "range",
							name = L.Width,
							desc = L.BarWidth_Desc..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							min = 1,
							max = 400,
							step = 1,
							order = 1
						},
						BarHeight = {
							type = "range",
							name = L.Height,
							desc = L.BarHeight_Desc..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							min = 1,
							max = 100,
							step = 1,
							order = 2
						},
						BarVerticalGrowdirection = {
							type = "select",
							name = L.VerticalGrowdirection,
							desc = L.VerticalGrowdirection_Desc..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							values = Data.VerticalDirections,
							order = 3
						},
						BarVerticalSpacing = {
							type = "range",
							name = L.VerticalSpacing,
							desc = L.VerticalSpacing..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							min = 0,
							max = 20,
							step = 1,
							order = 4
						},
						BarColumns = {
							type = "range",
							name = L.Columns,
							desc = L.Columns_Desc..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							min = 1,
							max = 4,
							step = 1,
							order = 5
						},
						BarHorizontalGrowdirection = {
							type = "select",
							name = L.VerticalGrowdirection,
							desc = L.VerticalGrowdirection_Desc..L.NotAvailableInCombat,
							hidden = function() return location.BarColumns < 2 end,
							disabled = InCombatLockdown,
							values = Data.HorizontalDirections,
							order = 6
						},
						BarHorizontalSpacing = {
							type = "range",
							name = L.HorizontalSpacing,
							desc = L.HorizontalSpacing..L.NotAvailableInCombat,
							hidden = function() return location.BarColumns < 2 end,
							disabled = InCombatLockdown,
							min = 0,
							max = 400,
							step = 1,
							order = 7
						},
						HealthBarSettings = {
							type = "group",
							name = L.HealthBarSettings,
							desc = L.HealthBarSettings_Desc,
							order = 8,
							args = {
								General = {
									type = "group",
									name = L.General,
									desc = "",
									--inline = true,
									order = 7,
									args = {
										HealthBar_Texture = {
											type = "select",
											name = L.BarTexture,
											desc = L.HealthBar_Texture_Desc,
											dialogControl = 'LSM30_Statusbar',
											values = AceGUIWidgetLSMlists.statusbar,
											width = "normal",
											order = 1
										},
										Fake = addHorizontalSpacing(2),
										HealthBar_Background = {
											type = "color",
											name = L.BarBackground,
											desc = L.HealthBar_Background_Desc,
											hasAlpha = true,
											width = "normal",
											order = 3
										},
										Fake = addVerticalSpacing(4),
										HealthBar_HealthPrediction_Enabled = {
											type = "toggle",
											name = COMPACT_UNIT_FRAME_PROFILE_DISPLAYHEALPREDICTION,
											width = "normal",
											order = 5,
										}
									}
								},
								Name = {
									type = "group",
									name = L.Name,
									desc = L.Name_Desc,
									order = 2,
									args = {
										NameTextSettings = {
											type = "group",
											name = "",
											--desc = L.TrinketSettings_Desc,
											inline = true,
											order = 1,
											args = addNormalTextSettings(location, "Name")
										},
									}
								},
								RoleIconSettings = {
									type = "group",
									name = L.RoleIconSettings,
									desc = L.RoleIconSettings_Desc,
									order = 3,
									args = {
										RoleIcon_Enabled = {
											type = "toggle",
											name = L.RoleIcon_Enabled,
											desc = L.RoleIcon_Enabled_Desc,
											width = "normal",
											order = 1
										},
										RoleIcon_Size = {
											type = "range",
											name = L.Size,
											desc = L.RoleIcon_Size_Desc,
											disabled = function() return not location.RoleIcon_Enabled end,
											min = 2,
											max = 40,
											step = 1,
											width = "normal",
											order = 2
										},
										RoleIcon_VerticalPosition = {
											type = "range",
											name = L.VerticalPosition,
											disabled = function() return not location.RoleIcon_Enabled end,
											min = 0,
											max = 50,
											step = 1,
											width = "normal",
											order = 3,
										}
									}
								},
								CovenantIconSettings = {
									type = "group",
									name = L.CovenantIconSettings,
									desc = L.CovenantIconSettings_Desc,
									order = 4,
									args = {
										CovenantIcon_Enabled = {
											type = "toggle",
											name = L.CovenantIcon_Enabled,
											desc = L.CovenantIcon_Enabled_Desc,
											width = "normal",
											order = 1
										},
										CovenantIcon_Size = {
											type = "range",
											name = L.Size,
											desc = L.CovenantIcon_Size_Desc,
											disabled = function() return not location.CovenantIcon_Enabled end,
											min = 2,
											max = 40,
											step = 1,
											width = "normal",
											order = 2
										},
										CovenantIcon_VerticalPosition = {
											type = "range",
											name = L.VerticalPosition,
											disabled = function() return not location.CovenantIcon_Enabled end,
											min = 0,
											max = 50,
											step = 1,
											width = "normal",
											order = 3,
										}
									}
								},
								TargetIndicator = {
									type = "group",
									name = L.TargetIndicator,
									desc = L.TargetIndicator_Desc,
									--childGroups = "select",
									--inline = true,
									order = 4,
									args = {
										NumericTargetindicator_Enabled = {
											type = "toggle",
											name = L.NumericTargetindicator,
											desc = L.NumericTargetindicator_Enabled_Desc:format(L[playerType == "Enemies" and "enemies" or "allies"]),
											width = "full",
											order = 1
										},
										NumericTargetindicatorTextSettings = {
											type = "group",
											name = "",
											--desc = L.TrinketSettings_Desc,
											disabled = function() return not location.NumericTargetindicator_Enabled end,
											inline = true,
											order = 2,
											args = addNormalTextSettings(location, "NumericTargetindicator")
										},
										Fake2 = addVerticalSpacing(3),
										SymbolicTargetindicator_Enabled = {
											type = "toggle",
											name = L.SymbolicTargetindicator_Enabled,
											desc = L.SymbolicTargetindicator_Enabled_Desc:format(L[playerType == "Enemies" and "enemy" or "ally"]),
											width = "full",
											order = 4
										}
									}
								}
							}
						},
						PowerBarSettings = {
							type = "group",
							name = L.PowerBarSettings,
							desc = L.PowerBarSettings_Desc,
							order = 8,
							args = {
								PowerBar_Enabled = {
									type = "toggle",
									name = L.PowerBar_Enabled,
									desc = L.PowerBar_Enabled_Desc,
									order = 1
								},
								PowerBar_Height = {
									type = "range",
									name = L.Height,
									desc = L.PowerBar_Height_Desc,
									disabled = function() return not location.PowerBar_Enabled end,
									min = 1,
									max = 10,
									step = 1,
									width = "normal",
									order = 2
								},
								PowerBar_Texture = {
									type = "select",
									name = L.BarTexture,
									desc = L.PowerBar_Texture_Desc,
									disabled = function() return not location.PowerBar_Enabled end,
									dialogControl = 'LSM30_Statusbar',
									values = AceGUIWidgetLSMlists.statusbar,
									width = "normal",
									order = 3
								},
								Fake = addHorizontalSpacing(4),
								PowerBar_Background = {
									type = "color",
									name = L.BarBackground,
									desc = L.PowerBar_Background_Desc,
									disabled = function() return not location.PowerBar_Enabled end,
									hasAlpha = true,
									width = "normal",
									order = 5
								}
							}
						},
						TrinketSettings = {
							type = "group",
							name = L.TrinketSettings,
							desc = L.TrinketSettings_Desc,
							order = 9,
							args = {
								Trinket_Enabled = {
									type = "toggle",
									name = L.Trinket_Enabled,
									desc = L.Trinket_Enabled_Desc,
									order = 1
								},
								TrinketPositioning = {
									type = "group",
									name = L.Position,
									disabled = function() return not location.Trinket_Enabled end,
									order = 2,
									args = addBasicPositionSettings(location, "Trinket")
								},
								Trinket_Width = {
									type = "range",
									name = L.Width,
									desc = L.Trinket_Width_Desc,
									disabled = function() return not location.Trinket_Enabled end,
									min = 1,
									max = 40,
									step = 1,
									order = 3
								},
								TrinketCooldownTextSettings = {
									type = "group",
									name = L.Countdowntext,
									--desc = L.TrinketSettings_Desc,
									disabled = function() return not location.Trinket_Enabled end,
									order = 4,
									args = addCooldownTextsettings(location, "Trinket")
								}
							}
						},
						RacialSettings = {
							type = "group",
							name = L.RacialSettings,
							desc = L.RacialSettings_Desc,
							order = 10,
							args = {
								Racial_Enabled = {
									type = "toggle",
									name = L.Racial_Enabled,
									desc = L.Racial_Enabled_Desc,
									order = 1
								},
								RacialPositioning = {
									type = "group",
									name = L.Position,
									disabled = function() return not location.Racial_Enabled end,
									order = 2,
									args = addBasicPositionSettings(location, "Racial")
								},
								Racial_Width = {
									type = "range",
									name = L.Width,
									desc = L.Racial_Width_Desc,
									disabled = function() return not location.Racial_Enabled end,
									min = 1,
									max = 40,
									step = 1,
									order = 3
								},
								RacialCooldownTextSettings = {
									type = "group",
									name = L.Countdowntext,
									--desc = L.TrinketSettings_Desc,
									disabled = function() return not location.Racial_Enabled end,
									order = 4,
									args = addCooldownTextsettings(location, "Racial")
								},
								RacialFilteringSettings = {
									type = "group",
									name = FILTER,
									desc = L.RacialFilteringSettings_Desc,
									disabled = function() return not location.Racial_Enabled end,
									--inline = true,
									order = 5,
									args = {
										RacialFiltering_Enabled = {
											type = "toggle",
											name = L.Filtering_Enabled,
											desc = L.RacialFiltering_Enabled_Desc,
											width = 'normal',
											order = 1
										},
										Fake = addHorizontalSpacing(2),
										RacialFiltering_Filterlist = {
											type = "multiselect",
											name = L.Filtering_Filterlist,
											desc = L.RacialFiltering_Filterlist_Desc,
											disabled = function() return not location.RacialFiltering_Enabled or not location.Racial_Enabled end,
											get = function(option, key)
												for spellID in pairs(Data.RacialNameToSpellIDs[key]) do
													return location.RacialFiltering_Filterlist[spellID]
												end
											end,
											set = function(option, key, state) -- value = spellname
												for spellID in pairs(Data.RacialNameToSpellIDs[key]) do
													location.RacialFiltering_Filterlist[spellID] = state or nil
												end
											end,
											values = Data.Racialnames,
											order = 3
										}
									}
								}
							}
						},
						SpecSettings = {
							type = "group",
							name = L.SpecSettings,
							desc = L.SpecSettings_Desc,
							order = 11,
							args = {
								Spec_Enabled = {
									type = "toggle",
									name = L.Spec_Enabled,
									desc = L.Spec_Enabled_Desc,
									order = 1
								},
								Spec_Width = {
									type = "range",
									name = L.Width,
									desc = L.Spec_Width_Desc,
									disabled = function() return not location.Spec_Enabled end,
									min = 1,
									max = 40,
									step = 1,
									order = 2
								},
								Fake = addVerticalSpacing(3),
								Spec_AuraDisplay_Enabled = {
									type = "toggle",
									name = L.Spec_AuraDisplay_Enabled,
									desc = L.Spec_AuraDisplay_Enabled_Desc,
									order = 4,
								},
								Fake1 = addVerticalSpacing(5),
								Spec_AuraDisplay_CooldownTextSettings = {
									type = "group",
									name = L.Countdowntext,
									--desc = L.TrinketSettings_Desc,
									disabled = function() return not location.Spec_AuraDisplay_Enabled end,
									inline = true,
									order = 6,
									args = addCooldownTextsettings(location, "Spec_AuraDisplay")
								}
							}
						},
						DrTrackingSettings = {
							type = "group",
							name = L.DrTrackingSettings,
							desc = L.DrTrackingSettings_Desc,
							order = 12,
							args = {
								DrTracking_Enabled = {
									type = "toggle",
									name = L.DrTracking_Enabled,
									desc = L.DrTracking_Enabled_Desc,
									order = 1
								},
								DrTracking_Container_PositioningSettings = {
									type = "group",
									name = L.Position,
									disabled = function() return not location.DrTracking_Enabled end,
									order = 2,
									args = addBasicPositionSettings(location, "DrTracking_Container")
								},
								DrTracking_HorizontalSpacing = {
									type = "range",
									name = L.DrTracking_Spacing,
									desc = L.DrTracking_Spacing_Desc,
									disabled = function() return not location.DrTracking_Enabled end,
									min = 0,
									max = 10,
									step = 1,
									order = 3
								},
								DrTracking_Container_Color = {
									type = "color",
									name = L.Container_Color,
									desc = L.DrTracking_Container_Color_Desc,
									disabled = function() return not location.DrTracking_Enabled end,
									hasAlpha = true,
									order = 4
								},
								DrTracking_Container_BorderThickness = {
									type = "range",
									name = L.BorderThickness,
									min = 1,
									max = 6,
									step = 1,
									disabled = function() return not location.DrTracking_Enabled end,
									order = 5
								},
								DrTracking_DisplayType = {
									type = "select",
									name = L.DisplayType,
									desc = L.DrTracking_DisplayType_Desc,
									disabled = function() return not location.DrTracking_Enabled end,
									values = Data.DisplayType,
									order = 6
								},
								DrTracking_GrowDirection = {
									type = "select",
									name = L.VerticalGrowdirection,
									desc = L.VerticalGrowdirection_Desc,
									disabled = function() return not location.DrTracking_Enabled end,
									values = Data.HorizontalDirections,
									order = 7
								},
								DrTrackingCooldownTextSettings = {
									type = "group",
									name = L.Countdowntext,
									--desc = L.TrinketSettings_Desc,
									disabled = function() return not location.DrTracking_Enabled end,
									order = 8,
									args = addCooldownTextsettings(location, "DrTracking")
								},
								Fake1 = addVerticalSpacing(6),
								DrTrackingFilteringSettings = {
									type = "group",
									name = FILTER,
									--desc = L.DrTrackingFilteringSettings_Desc,
									disabled = function() return not location.DrTracking_Enabled end,
									--inline = true,
									order = 9,
									args = {
										DrTrackingFiltering_Enabled = {
											type = "toggle",
											name = L.Filtering_Enabled,
											desc = L.DrTrackingFiltering_Enabled_Desc,
											width = 'normal',
											order = 1
										},
										DrTrackingFiltering_Filterlist = {
											type = "multiselect",
											name = L.Filtering_Filterlist,
											desc = L.DrTrackingFiltering_Filterlist_Desc,
											disabled = function() return not location.DrTrackingFiltering_Enabled end,
											get = function(option, key)
												return location.DrTrackingFiltering_Filterlist[key]
											end,
											set = function(option, key, state) -- key = category name
												location.DrTrackingFiltering_Filterlist[key] = state or nil
											end,
											values = Data.DrCategorys,
											order = 2
										}
									}
								}
							}
						},
						AurasSettings = {
							type = "group",
							name = L.AurasSettings,
							desc = L.AurasSettings_Desc,
							order = 13,
							args = {
								Auras_Enabled = {
									type = "toggle",
									name = L.Auras_Enabled,
									desc = L.Auras_Enabled_Desc,
									order = 1
								},
								Auras_BuffsSettings = {
									type = "group",
									name = L.Buffs,
									disabled = function() return not location.Auras_Enabled end,
									order = 2,
									args = {
										Auras_Buffs_Enabled = {
											type = "toggle",
											name = ENABLE,
											desc = SHOW_BUFFS,
											order = 1
										},
										Auras_Buffs_Container_IconSettings = {
											type = "group",
											name = L.BuffIcon,
											disabled = function() return not location.Auras_Buffs_Enabled end,
											order = 2,
											args = addIconPositionSettings(location, "Auras_Buffs"),
										},
										Auras_Buffs_Container_PositioningSettings = {
											type = "group",
											name = L.ContainerPosition,
											disabled = function() return not location.Auras_Buffs_Enabled end,
											args = addContainerPositionSettings(location, "Auras_Buffs_Container"),
											order = 3
										},
										Auras_Buffs_StacktextSettings = {
											type = "group",
											name = L.AurasStacktextSettings,
											--desc = L.MyAuraSettings_Desc,
											disabled = function() return not location.Auras_Buffs_Enabled end,
											order = 4,
											args = addNormalTextSettings(location, "Auras_Buffs")
										},
										Auras_Buffs_CooldownTextSettings = {
											type = "group",
											name = L.Countdowntext,
											--desc = L.TrinketSettings_Desc,
											disabled = function() return not location.Auras_Buffs_Enabled end,
											order = 5,
											args = addCooldownTextsettings(location, "Auras_Buffs")
										},
										Auras_Buffs_FilteringSettings = {
											type = "group",
											name = FILTER,
											desc = L.AurasFilteringSettings_Desc,
											disabled = function() return not location.Auras_Buffs_Enabled end,
											order = 9,
											args = {
												Auras_Buffs_Filtering_Enabled = {
													type = "toggle",
													name = L.Filtering_Enabled,
													width = 'normal',
													order = 1
												},
												Auras_Buffs_FilterSettings = {
													type = "group",
													name = L.FilterSettings,
													desc = L.AurasFilteringSettings_Desc,
													disabled = function() return not location.Auras_Buffs_Filtering_Enabled end,
													order = 2,
													args = {
														Auras_Buffs_Filtering_Mode = {
															type = "select",
															name = L.Auras_Filtering_Mode,
															desc = L.Auras_Filtering_Mode_Desc,
															width = 'normal',
															values = {
																Custom = L.AurasCustomConditions,
																Blizz = L.BlizzlikeAuraFiltering
															},
															order = 1
														},
														Auras_Buffs_CustomFilteringSettings = {
															type = "group",
															name = L.AurasCustomConditions,
															disabled = function() 
																return not (location.Auras_Buffs_Filtering_Mode == "Custom")
															end,
															inline = true,
															order = 2,
															args = {
																Auras_Buffs_CustomFiltering_ConditionsMode = {
																	type = "select",
																	name = L.Auras_CustomFiltering_ConditionsMode,
																	desc = L.Auras_CustomFiltering_ConditionsMode_Desc,
																	width = 'normal',
																	values = {
																		All = L.Auras_CustomFiltering_Conditions_All,
																		Any = L.Auras_CustomFiltering_Conditions_Any
																	},
																	order = 1
																},

																Fake = addVerticalSpacing(2),
																Auras_Buffs_ShowMine = {
																	type = "toggle",
																	name = L.ShowMine,
																	desc = L.ShowMine_Desc:format(L.Buffs),
																	order = 4,
																},
																Auras_Buffs_SpellIDFiltering_Enabled = {
																	type = "toggle",
																	name = L.SpellID_Filtering,
																	order = 8
																},
																Auras_Buffs_SpellIDFiltering__AddSpellID = {
																	type = "input",
																	name = L.AurasFiltering_AddSpellID,
																	desc = L.AurasFiltering_AddSpellID_Desc,
																	hidden = function() return not (location.Auras_Buffs_Filtering_Enabled and location.Auras_Buffs_SpellIDFiltering_Enabled) end,
																	get = function() return "" end,
																	set = function(option, value, state)
																		local spellIDs = {strsplit(",", value)}
																		for i = 1, #spellIDs do
																			local spellID = tonumber(spellIDs[i])
																			location.Auras_Buffs_SpellIDFiltering_Filterlist[spellID] = true
																		end
																	end,
																	width = 'double',
																	order = 9
																},
																Fake2 = addVerticalSpacing(10),
																Auras_Buffs_SpellIDFiltering_Filterlist = {
																	type = "multiselect",
																	name = L.Filtering_Filterlist,
																	desc = L.AurasFiltering_Filterlist_Desc:format(L.Buffs),
																	hidden = function() return not (location.Auras_Buffs_Filtering_Enabled and location.Auras_Buffs_SpellIDFiltering_Enabled) end,
																	get = function()
																		return true --to make it checked
																	end,
																	set = function(option, value) 
																		location.Auras_Buffs_SpellIDFiltering_Filterlist[value] = nil
																	end,
																	values = function()
																		local valueTable = {}
																		for spellID in pairs(location.Auras_Buffs_SpellIDFiltering_Filterlist) do
																			valueTable[spellID] = spellID..": "..(GetSpellInfo(spellID) or "")
																		end
																		return valueTable
																	end,
																	order = 11
																}
															}
														}
													}
												}
											}
										}
									}
								},
								Auras_DebuffsSettings = {
									type = "group",
									name = L.Debuffs,
									disabled = function() return not location.Auras_Enabled end,
									order = 3,
									args = {
										Auras_Debuffs_Enabled = {
											type = "toggle",
											name = ENABLE,
											desc = SHOW_DEBUFFS,
											order = 1
										},
										Fake = addVerticalSpacing(2),
										Auras_Debuffs_Coloring_Enabled = {
											type = "toggle",
											name = L.Auras_Debuffs_Coloring_Enabled,
											desc = L.Auras_Debuffs_Coloring_Enabled_Desc,
											disabled = function() return not location.Auras_Debuffs_Enabled end,
											order = 3
										},
										Auras_Debuffs_DisplayType = {
											type = "select",
											name = L.DisplayType,
											disabled = function() return not location.Auras_Debuffs_Coloring_Enabled end,
											values = Data.DisplayType,
											order = 4
										},
										Auras_Debuffs_Container_IconSettings = {
											type = "group",
											name = L.DebuffIcon,
											disabled = function() return not (location.Auras_Debuffs_Enabled) end,
											order = 5,
											args = addIconPositionSettings(location, "Auras_Debuffs"),
										},
										Auras_Debuffs_Container_PositioningSettings = {
											type = "group",
											name = L.ContainerPosition,
											disabled = function() return not location.Auras_Debuffs_Enabled end,
											args = addContainerPositionSettings(location, "Auras_Debuffs_Container"),
											order = 6
										},
										Auras_Debuffs_StacktextSettings = {
											type = "group",
											name = L.AurasStacktextSettings,
											--desc = L.MyAuraSettings_Desc,
											disabled = function() return not location.Auras_Debuffs_Enabled end,
											order = 7,
											args = addNormalTextSettings(location, "Auras_Debuffs")
										},
										Auras_Debuffs_CooldownTextSettings = {
											type = "group",
											name = L.Countdowntext,
											--desc = L.TrinketSettings_Desc,
											disabled = function() return not location.Auras_Debuffs_Enabled end,
											order = 8,
											args = addCooldownTextsettings(location, "Auras_Debuffs")
										},
										Auras_Debuffs_FilteringSettings = {
											type = "group",
											name = FILTER,
											desc = L.AurasFilteringSettings_Desc,
											disabled = function() return not location.Auras_Debuffs_Enabled end,
											order = 9,
											args = {
												Auras_Debuffs_Filtering_Enabled = {
													type = "toggle",
													name = L.Filtering_Enabled,
													width = 'normal',
													order = 1
												},
												Auras_Debuffs_FilterSettings = {
													type = "group",
													name = L.FilterSettings,
													desc = L.AurasFilteringSettings_Desc,
													disabled = function() return not location.Auras_Debuffs_Filtering_Enabled end,
													order = 2,
													args = {
														Auras_Debuffs_Filtering_Mode = {
															type = "select",
															name = L.Auras_Filtering_Mode,
															desc = L.Auras_Filtering_Mode_Desc,
															width = 'normal',
															values = {
																Custom = L.AurasCustomConditions,
																Blizz = L.BlizzlikeAuraFiltering
															},
															order = 1
														},
														Auras_Debuffs_CustomFilteringSettings = {
															type = "group",
															name = L.AurasCustomConditions,
															disabled = function() 
																return not (location.Auras_Debuffs_Filtering_Mode == "Custom" )
															end,
															inline = true,
															order = 2,
															args = {
																Auras_Debuffs_CustomFiltering_ConditionsMode = {
																	type = "select",
																	name = L.Auras_CustomFiltering_ConditionsMode,
																	desc = L.Auras_CustomFiltering_ConditionsMode_Desc,
																	width = 'normal',
																	values = {
																		All = L.Auras_CustomFiltering_Conditions_All,
																		Any = L.Auras_CustomFiltering_Conditions_Any
																	},
																	order = 1
																},

																Fake = addVerticalSpacing(2),
																Auras_Debuffs_ShowMine = {
																	type = "toggle",
																	name = L.ShowMine,
																	desc = L.ShowMine_Desc:format(L.Debuffs),
																	order = 4,
																},
																Fake1 = addVerticalSpacing(5),
																Auras_Debuffs_DebuffTypeFiltering_Enabled = {
																	type = "toggle",
																	name = L.DebuffType_Filtering,
																	desc = L.DebuffType_Filtering_Desc,
																	width = 'normal',
																	order = 6
																},
																Auras_Debuffs_DebuffTypeFiltering_Filterlist = {
																	type = "multiselect",
																	name = "",
																	desc = "",
																	hidden = function() return not (location.Auras_Debuffs_Filtering_Enabled and location.Auras_Debuffs_DebuffTypeFiltering_Enabled) end,
																	get = function(option, key)
																		return location.Auras_Debuffs_DebuffTypeFiltering_Filterlist[key]
																	end,
																	set = function(option, key, state) -- value = spellname
																		location.Auras_Debuffs_DebuffTypeFiltering_Filterlist[key] = state
																	end,
																	width = 'normal',
																	values = Data.DebuffTypes,
																	order = 7
																},
																Auras_Debuffs_SpellIDFiltering_Enabled = {
																	type = "toggle",
																	name = L.SpellID_Filtering,
																	order = 8
																},
																Auras_Debuffs_SpellIDFiltering__AddSpellID = {
																	type = "input",
																	name = L.AurasFiltering_AddSpellID,
																	desc = L.AurasFiltering_AddSpellID_Desc,
																	hidden = function() return not (location.Auras_Debuffs_Filtering_Enabled and location.Auras_Debuffs_SpellIDFiltering_Enabled) end,
																	get = function() return "" end,
																	set = function(option, value, state)
																		local spellIDs = {strsplit(",", value)}
																		for i = 1, #spellIDs do
																			local spellID = tonumber(spellIDs[i])
																			location.Auras_Debuffs_SpellIDFiltering_Filterlist[spellID] = true
																		end
																	end,
																	width = 'double',
																	order = 9
																},
																Fake2 = addVerticalSpacing(10),
																Auras_Debuffs_SpellIDFiltering_Filterlist = {
																	type = "multiselect",
																	name = L.Filtering_Filterlist,
																	desc = L.AurasFiltering_Filterlist_Desc:format(L.debuff),
																	hidden = function() return not (location.Auras_Debuffs_Filtering_Enabled and location.Auras_Debuffs_SpellIDFiltering_Enabled) end,
																	get = function()
																		return true --to make it checked
																	end,
																	set = function(option, value) 
																		location.Auras_Debuffs_SpellIDFiltering_Filterlist[value] = nil
																	end,
																	values = function()
																		local valueTable = {}
																		for spellID in pairs(location.Auras_Debuffs_SpellIDFiltering_Filterlist) do
																			valueTable[spellID] = spellID..": "..(GetSpellInfo(spellID) or "")
																		end
																		return valueTable
																	end,
																	order = 11
																}
															}
		
														}

													}
												}

												
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	end
	local BGSize = "15"
	
	settings["15"].args.BarSettings.args.ObjectiveAndRespawnSettings = {
		type = "group",
		name = L.ObjectiveAndRespawnSettings,
		desc = L.ObjectiveAndRespawnSettings_Desc,
		order = 13,
		args = {
			ObjectiveAndRespawn_ObjectiveEnabled = {
				type = "toggle",
				name = L.ObjectiveAndRespawn_ObjectiveEnabled,
				desc = L.ObjectiveAndRespawn_ObjectiveEnabled_Desc,
				order = 1
			},
			ObjectiveAndRespawnPositioning = {
				type = "group",
				name = L.Position,
				disabled = function() return not location["15"].ObjectiveAndRespawn_ObjectiveEnabled end,
				order = 2,
				args = addBasicPositionSettings(location["15"], "ObjectiveAndRespawn")
			},
			ObjectiveAndRespawn_Width = {
				type = "range",
				name = L.Width,
				desc = L.ObjectiveAndRespawn_Width_Desc,
				disabled = function() return not location["15"].ObjectiveAndRespawn_ObjectiveEnabled end,
				min = 1,
				max = 50,
				step = 1,
				order = 3
			},
			ObjectiveAndRespawnTextSettings = {
				type = "group",
				name = "",
				--desc = L.TrinketSettings_Desc,
				disabled = function() return not location["15"].ObjectiveAndRespawn_ObjectiveEnabled end,
				inline = true,
				order = 4,
				args = addNormalTextSettings(location["15"], "ObjectiveAndRespawn")
			}
		}
	}	
	
	return settings
end






function BattleGroundEnemies:SetupOptions()
	local location = self.db.profile
	self.options = {
		type = "group",
		name = "BattleGroundEnemies " .. GetAddOnMetadata(addonName, "Version"),
		childGroups = "tab",
		get = function(option)
			return getOption(location, option)
		end,
		set = function(option, ...)
			return setOption(location, option, ...)
		end,
		args = {
			TestmodeSettings = {
				type = "group",
				name = L.TestmodeSettings,
				disabled = function() return InCombatLockdown() or (self:IsShown() and not self.TestmodeActive) end,
				inline = true,
				order = 1,
				args = {
					Testmode_BGSize = {
						type = "select",
						name = L.BattlegroundSize,
						order = 1,
						get = function() return self.BGSize end,
						set = function(option, value)
							self:BGSizeCheck(value)
							
							if self.TestmodeActive then
								self:FillData()
							end
						end,
						values = {[15] = L.BGSize_15, [40] = L.BGSize_40}
					},
					Testmode_Enabled = {
						type = "execute",
						name = L.Testmode_Toggle,
						desc = L.Testmode_Toggle_Desc,
						disabled = function() return InCombatLockdown() or (self:IsShown() and not self.TestmodeActive) or not self.BGSize end,
						func = self.ToggleTestmode,
						order = 2
					},
					Testmode_ToggleAnimation = {
						type = "execute",
						name = L.Testmode_ToggleAnimation,
						desc = L.Testmode_ToggleAnimation_Desc,
						disabled = function() return InCombatLockdown() or not self.TestmodeActive end,
						func = self.ToggleTestmodeOnUpdate,
						order = 3
					}
				}
			},
			GeneralSettings = {
				type = "group",
				name = L.GeneralSettings,
				desc = L.GeneralSettings_Desc,
				order = 3,
				args = {
					Locked = {
						type = "toggle",
						name = L.Locked,
						desc = L.Locked_Desc,
						order = 1
					},
					DisableArenaFrames = {
						type = "toggle",
						name = L.DisableArenaFrames,
						desc = L.DisableArenaFrames_Desc,
						set = function(option, value) 
							setOption(location, option, value)
							self:ToggleArenaFrames()
						end,
						order = 3
					},
					Font = {
						type = "select",
						name = L.Font,
						desc = L.Font_Desc,
						dialogControl = "LSM30_Font",
						values = AceGUIWidgetLSMlists.font,
						order = 4
					},
					MyTarget_Color = {
						type = "color",
						name = L.MyTarget_Color,
						desc = L.MyTarget_Color_Desc,
						hasAlpha = true,
						order = 7
					},
					MyFocus_Color = {
						type = "color",
						name = L.MyFocus_Color,
						desc = L.MyFocus_Color_Desc,
						hasAlpha = true,
						order = 8
					},
					Fake1 = addVerticalSpacing(10),
					ShowTooltips = {
						type = "toggle",
						name = L.ShowTooltips,
						desc = L.ShowTooltips_Desc,
						order = 11
					}
				}
			},
			RBGSettings = {
				type = "group",
				name = L.RBGSpecificSettings,
				desc = L.RBGSpecificSettings_Desc,
				--inline = true,
				order = 14,
				get = function(option)
					return getOption(location.RBG, option)
				end,
				set = function(option, ...)
					return setOption(location.RBG, option, ...)
				end,
				args = {
					Notifications = {
						type = "group",
						name = COMMUNITIES_NOTIFICATION_SETTINGS,
						order = 1,
						args = {
							EnemiesTargetingMe = {
								type = "group",
								name = L.IAmTargeted,
								order = 1,
								args = {
									EnemiesTargetingMe_Enabled = {
										type = "toggle",
										name = ENABLE,
										desc = L.EnemiesTargetingMe_Enabled_Desc,
										order = 1
									},
									EnemiesTargetingMe_Amount = {
										type = "range",
										name = L.TargetAmount,
										desc = L.TargetAmount_Me,
										min = 1,
										max = 10,
										step = 1,
										disabled = function() return not location.RBG.EnemiesTargetingMe_Enabled end,
										order = 2
										
									},
									EnemiesTargetingMe_Sound = {
										type = "select",
										name = SOUND,
										values = AceGUIWidgetLSMlists.sound,
										width = "full",
										dialogControl = "LSM30_Sound",
										disabled = function() return not location.RBG.EnemiesTargetingMe_Enabled end,
										order = 3
									}
									
								}
								
								

							},
							EnemiesTargetingAllies = {
								type = "group",
								name = L.AllyIsTargeted,
								order = 2,
								args = {
									EnemiesTargetingAllies_Enabled = {
										type = "toggle",
										name = ENABLE,
										desc = L.EnemiesTargetingAllies_Enabled_Desc,
										order = 1
									},
									EnemiesTargetingAllies_Amount = {
										type = "range",
										name = L.TargetAmount,
										desc = L.TargetAmount_Ally,
										min = 1,
										max = 10,
										step = 1,
										disabled = function() return not location.RBG.EnemiesTargetingAllies_Enabled end,
										order = 2
										
									},
									EnemiesTargetingAllies_Sound = {
										type = "select",
										name = SOUND,
										values = AceGUIWidgetLSMlists.sound,
										width = "full",
										dialogControl = "LSM30_Sound",
										disabled = function() return not location.RBG.EnemiesTargetingAllies_Enabled end,
										order = 3
									}

								}
								

							}
							
						}
					},
					-- PositiveSound = {
						-- type = "select",
						-- name = L.PositiveSound,
						-- desc = L.PositiveSound_Desc,
						-- disabled = function() return not self.config[BGSize].Notifications_Enabled end,
						-- dialogControl = 'LSM30_Sound',
						-- values = AceGUIWidgetLSMlists.sound,
						-- order = 2
					-- },
					-- NegativeSound = {
						-- type = "select",
						-- name = L.NegativeSound,
						-- desc = L.NegativeSound_Desc,
						-- disabled = function() return not self.config[BGSize].Notifications_Enabled end,
						-- dialogControl = 'LSM30_Sound',
						-- values = AceGUIWidgetLSMlists.sound,
						-- order = 3
					-- },

					
					ObjectiveAndRespawn = {
						type = "group",
						name = L.ObjectiveAndRespawn_RespawnEnabled,
						order = 4,
						args = {
							ObjectiveAndRespawn_RespawnEnabled = {
								type = "toggle",
								name = ENABLE,
								desc = L.ObjectiveAndRespawn_RespawnEnabled_Desc,
								order = 1
							},
							ObjectiveAndRespawnCooldownTextSettings = {
								type = "group",
								name = L.Countdowntext,
								--desc = L.TrinketSettings_Desc,
								disabled = function() return not location.RBG.ObjectiveAndRespawn_RespawnEnabled end,
								order = 5,
								args = addCooldownTextsettings(location.RBG, "ObjectiveAndRespawn")
							}
						}
					},
					TargetCallingSettings = {
						type = "group",
						name = L.TargetCalling,
						order = 6,
						args = {
							TargetCalling_SetMark = {
								type = "toggle",
								name = L.TargetCallingSetMark,
								desc = L.TargetCallingSetMark_Desc,
								order = 1,
								width = "full",
							},
							TargetCalling_NotificationEnable = {
								type = "toggle",
								name = L.TargetCallingNotificationEnable,
								desc = L.TargetCallingNotificationEnable_Desc,
								order = 2,
								width = "full",
							},
							TargetCalling_NotificationSound = {
								type = "select",
								name = SOUND,
								values = AceGUIWidgetLSMlists.sound,
								dialogControl = "LSM30_Sound",
								disabled = function() return not location.RBG.TargetCalling_NotificationEnable end,
								order = 3,
								width = "full",
							}
								
							
							-- Sounds = {
							-- 	type = "group",
							-- 	name = SOUNDS,
							-- 	order = 2,
							-- 	args = {
		
							-- 		
							-- 	}
		
							-- }
						}
						
					}
				}
			},
			EnemySettings = {
				type = "group",
				name = L.Enemies,
				childGroups = "tab",
				order = 4,
				args = addEnemyAndAllySettings(self.Enemies)
			},
			AllySettings = {
				type = "group",
				name = L.Allies,
				childGroups = "tab",
				order = 5,
				args = addEnemyAndAllySettings(self.Allies)
			}

		}
	}


	AceConfigRegistry:RegisterOptionsTable("BattleGroundEnemies", self.options)
		
	
	
	--add profile tab to the options 
	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.options.args.profiles.order = -1
	self.options.args.profiles.disabled = InCombatLockdown
	
end

SLASH_BattleGroundEnemies1, SLASH_BattleGroundEnemies2 = "/BattleGroundEnemies", "/bge"
SlashCmdList["BattleGroundEnemies"] = function(msg)
	AceConfigDialog:Open("BattleGroundEnemies")
end
