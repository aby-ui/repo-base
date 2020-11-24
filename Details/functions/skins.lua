
local _detalhes = _G._detalhes
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
local _

	--> install skin function:
	function _detalhes:InstallSkin (skin_name, skin_table)
		if (not skin_name) then
			return false -- skin without a name
		elseif (_detalhes.skins [skin_name]) then
			return false -- skin with this name already exists
		end
		
		if (not skin_table.file) then
			return false -- no skin file
		end
		
		skin_table.author = skin_table.author or ""
		skin_table.version = skin_table.version or ""
		skin_table.site = skin_table.site or ""
		skin_table.desc = skin_table.desc or ""
		
		_detalhes.skins [skin_name] = skin_table
		return true
	end
	
	function _detalhes:GetSkin (skin_name)
		return _detalhes.skins [skin_name]
	end
	
	local reset_tooltip = function()
		_detalhes:SetTooltipBackdrop ("Blizzard Tooltip", 16, {1, 1, 1, 1})
		_detalhes:DelayOptionsRefresh()
	end
	local set_tooltip_elvui1 = function()
		_detalhes:SetTooltipBackdrop ("Blizzard Tooltip", 16, {0, 0, 0, 1})
		_detalhes:DelayOptionsRefresh()
	end
	local set_tooltip_elvui2 = function()
		_detalhes:SetTooltipBackdrop ("Blizzard Tooltip", 16, {1, 1, 1, 0})
		_detalhes:DelayOptionsRefresh()
	end
	
	--> install wow interface skin:
	_detalhes:InstallSkin ("WoW Interface", {
		file = [[Interface\AddOns\Details\images\skins\default_skin.blp]], 
		author = "Details!", 
		version = "1.0", 
		site = "unknown", 
		desc = "This was the first skin made for Details!, inspired in the standard wow interface", 
		
		can_change_alpha_head = false, 
		icon_anchor_main = {-1, 1}, 
		icon_anchor_plugins = {-9, -7}, 
		icon_plugins_size = {19, 19},
		
		-- the four anchors:
		icon_point_anchor = {-37, 0},
		left_corner_anchor = {-107, 0},
		right_corner_anchor = {96, 0},

		icon_point_anchor_bottom = {-37, 0},
		left_corner_anchor_bottom = {-107, 0},
		right_corner_anchor_bottom = {96, 0},
		
		attribute_icon_anchor = {34, -6},
		attribute_icon_size = {24, 24},
		
		micro_frames = {left = "DETAILS_STATUSBAR_PLUGIN_THREAT"},
		
		instance_cprops = {
			["menu_icons_size"] = 0.85,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["menu_anchor"] = {
				13, -- [1]
				1, -- [2]
				["side"] = 2,
			},
			["bg_r"] = 0.0941,
			["color_buttons"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["bars_sort_direction"] = 1,
			["attribute_text"] = {
				["enabled"] = true,
				["shadow"] = false,
				["side"] = 1,
				["text_color"] = {
					0.823529411764706, -- [1]
					0.549019607843137, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["custom_text"] = "{name}",
				["text_face"] = "Friz Quadrata TT",
				["anchor"] = {
					6, -- [1]
					3, -- [2]
				},
				["text_size"] = 10,
				["enable_custom_text"] = false,
			},
			["micro_displays_side"] = 2,
			["auto_hide_menu"] = {
				["left"] = false,
				["right"] = false,
			},
			["desaturated_menu"] = false,
			["plugins_grow_direction"] = 1,
			["menu_icons"] = {
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				false, -- [6]
				["space"] = -1,
				["shadow"] = true,
			},
			["show_sidebars"] = true,
			["menu_anchor_down"] = {
				-14, -- [1]
				-3, -- [2]
				["side"] = 2,
			},
			["backdrop_texture"] = "Details Ground",
			["statusbar_info"] = {
				["alpha"] = 1,
				["overlay"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
			},
			["toolbar_side"] = 1,
			["bg_g"] = 0.0941,
			["bars_grow_direction"] = 1,
			["row_info"] = {
				["textR_outline"] = true,
				["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
				["textL_outline"] = true,
				["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
				["textR_show_data"] = {
					true, -- [1]
					true, -- [2]
					true, -- [3]
				},
				["textL_enable_custom_text"] = false,
				["fixed_text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["space"] = {
					["right"] = -5,
					["left"] = 3,
					["between"] = 1,
				},
				["texture_background_class_color"] = false,
				["start_after_icon"] = true,
				["font_face_file"] = "Fonts\\ARIALN.TTF",
				["textL_custom_text"] = "{data1}. {data3}{data2}",
				["font_size"] = 16,
				["height"] = 21,
				["texture_file"] = "Interface\\AddOns\\Details\\images\\bar4",
				["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
				["textR_bracket"] = "(",
				["textR_enable_custom_text"] = false,
				["fixed_texture_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
				},
				["textL_show_number"] = true,
				["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
				["texture"] = "Details Serenity",
				["models"] = {
					["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
					["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
					["upper_alpha"] = 0.5,
					["lower_enabled"] = false,
					["lower_alpha"] = 0.1,
					["upper_enabled"] = false,
				},
				["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
				["texture_background"] = "DGround",
				["use_spec_icons"] = true,
				["textR_class_colors"] = false,
				["alpha"] = 1,
				["no_icon"] = false,
				["percent_type"] = 1,
				["fixed_texture_background_color"] = {
					0.619607, -- [1]
					0.619607, -- [2]
					0.619607, -- [3]
					0.116164, -- [4]
				},
				["font_face"] = "Accidental Presidency",
				["texture_class_colors"] = true,
				["backdrop"] = {
					["enabled"] = false,
					["texture"] = "Details BarBorder 2",
					["color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						0.305214, -- [4]
					},
					["size"] = 6,
				},
				["fast_ps_update"] = false,
				["textR_separator"] = ",",
				["textL_class_colors"] = false,
			},
			["show_statusbar"] = false,
			["bg_alpha"] = 0.699999988079071,
			["wallpaper"] = {
				["enabled"] = false,
				["texcoord"] = {
					0, -- [1]
					1, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["overlay"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["anchor"] = "all",
				["height"] = 0,
				["alpha"] = 0.5,
				["width"] = 0,
			},
			["stretch_button_side"] = 1,
			["hide_icon"] = false,
			["bg_b"] = 0.0941,
		},
		
		skin_options = {
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP"], func = reset_tooltip, desc = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"], func = set_tooltip_elvui2, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"]},
		}
	})

	local Minimalistic_Shadow = function()
	
		local instance = _G.DetailsOptionsWindow and _G.DetailsOptionsWindow.instance
		
		if (instance) then
			instance:ToolbarMenuSetButtonsOptions (nil, true)
			instance:AttributeMenu (nil, nil, nil, nil, nil, nil, nil, true)
			instance:AttributeMenu (nil, nil, 4)
			
			if (_detalhes.options_group_edit) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:ToolbarMenuSetButtonsOptions (nil, true)
						this_instance:AttributeMenu (nil, nil, nil, nil, nil, nil, nil, true)
						this_instance:AttributeMenu (nil, nil, 4)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
	
	end
	
	_detalhes:InstallSkin ("Minimalistic", {
		file = [[Interface\AddOns\Details\images\skins\classic_skin_v1.blp]],
		author = "Details!", 
		version = "1.0", 
		site = "unknown", 
		desc = "Simple skin with soft gray color and half transparent frames.", --\n
		
		--micro frames
		micro_frames = {
			color = {1, 1, 1, 1}, 
			font = "Accidental Presidency", 
			size = 10,
			textymod = 1,
		},
		
		can_change_alpha_head = true, 
		icon_anchor_main = {-1, -5}, 
		icon_anchor_plugins = {-7, -13}, 
		icon_plugins_size = {19, 18},
		
		--anchors:
		icon_point_anchor = {-37, 0},
		left_corner_anchor = {-107, 0},
		right_corner_anchor = {96, 0},

		icon_point_anchor_bottom = {-37, 12},
		left_corner_anchor_bottom = {-107, 0},
		right_corner_anchor_bottom = {96, 0},
		
		icon_on_top = true,
		icon_ignore_alpha = true,
		icon_titletext_position = {3, 3},
		
		--overwrites
		instance_cprops = {
			["menu_icons_size"] = 0.850000023841858,
			["color"] = {
				0.0705882352941177, -- [1]
				0.0705882352941177, -- [2]
				0.0705882352941177, -- [3]
				0.639196664094925, -- [4]
			},
			["menu_anchor"] = {
				16, -- [1]
				0, -- [2]
				["side"] = 2,
			},
			["bg_r"] = 0.0941176470588235,
			["color_buttons"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["menu_anchor_down"] = {
				16, -- [1]
				-3, -- [2]
			},
			["attribute_text"] = {
				["enabled"] = true,
				["shadow"] = false,
				["side"] = 1,
				["text_size"] = 12,
				["custom_text"] = "{name}",
				["text_face"] = "Accidental Presidency",
				["anchor"] = {
					-18, -- [1]
					3, -- [2]
				},
				["text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["enable_custom_text"] = false,
			},
			["bg_alpha"] = 0.183960914611816,
			["plugins_grow_direction"] = 1,
			["menu_icons"] = {
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				false, -- [6]
				["space"] = -1,
				["shadow"] = true,
			},
			["desaturated_menu"] = false,
			["micro_displays_side"] = 2,
			["statusbar_info"] = {
				["alpha"] = 0.3777777777777, -- [4]
				["overlay"] = {
				0.333333333333333, -- [1]
				0.333333333333333, -- [2]
				0.333333333333333, -- [3]
				
				},
			},
			["hide_icon"] = true,
			["instance_button_anchor"] = {
				-27, -- [1]
				1, -- [2]
			},
			["toolbar_side"] = 1,
			["bg_g"] = 0.0941176470588235,
			["backdrop_texture"] = "Details Ground",
			["show_statusbar"] = false,
			["show_sidebars"] = false,
			["wallpaper"] = {
				["enabled"] = false,
				["texcoord"] = {
					0, -- [1]
					1, -- [2]
					0, -- [3]
					0.7, -- [4]
				},
				["overlay"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["anchor"] = "all",
				["height"] = 114.042518615723,
				["alpha"] = 0.5,
				["width"] = 283.000183105469,
			},
			["stretch_button_side"] = 1,
			["row_info"] = {
				["textR_outline"] = false,
				["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
				["textL_outline"] = false,
				["textR_outline_small"] = true,
				["textL_outline_small"] = true,
				["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
				["textR_show_data"] = {
					true, -- [1]
					true, -- [2]
					false, -- [3]
				},
				["textL_enable_custom_text"] = false,
				["fixed_text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["space"] = {
					["right"] = 0,
					["left"] = 0,
					["between"] = 1,
				},
				["texture_background_class_color"] = false,
				["start_after_icon"] = true,
				["font_face_file"] = "Interface\\Addons\\Details\\fonts\\Accidental Presidency.ttf",
				["textL_custom_text"] = "{data1}. {data3}{data2}",
				["font_size"] = 16,
				["height"] = 21,
				["texture_file"] = "Interface\\AddOns\\Details\\images\\BantoBar",
				["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
				["textR_bracket"] = "(",
				["textR_enable_custom_text"] = false,
				["fixed_texture_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
				},
				["textL_show_number"] = true,
				["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
				["texture"] = "BantoBar",
				["use_spec_icons"] = true,
				["textR_class_colors"] = false,
				["textL_class_colors"] = false,
				["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar4_reverse",
				["texture_background"] = "Details D'ictum (reverse)",
				["alpha"] = 1,
				["no_icon"] = false,
				["percent_type"] = 1,
				["fixed_texture_background_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					0.150228589773178, -- [4]
				},
				["font_face"] = "Accidental Presidency",
				["texture_class_colors"] = true,
				["models"] = {
					["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
					["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
					["upper_alpha"] = 0.5,
					["lower_enabled"] = false,
					["lower_alpha"] = 0.1,
					["upper_enabled"] = false,
				},
				["fast_ps_update"] = false,
				["textR_separator"] = "NONE",
				["backdrop"] = {
					["enabled"] = false,
					["size"] = 12,
					["color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["texture"] = "Details BarBorder 2",
				},
			},
			["bg_b"] = 0.0941176470588235,
		},
		
		callback = function (skin, instance, just_updating)
			--none
		end,
		
		skin_options = {
			{spacement = true, type = "button", name = "Shadowy Title Bar", func = Minimalistic_Shadow, desc = "Adds shadow on title bar components."},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP"], func = reset_tooltip, desc = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"], func = set_tooltip_elvui2, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"]},
		}
		
	})
	
	_detalhes:InstallSkin ("Minimalistic v2", {
		file = [[Interface\AddOns\Details\images\skins\classic_skin.blp]],
		author = "Details!", 
		version = "1.0", 
		site = "unknown", 
		desc = "Same as the first Minimalistic, but this one is more darker and less transparent.", 
		
		--micro frames
		micro_frames = {
			color = {1, 1, 1, 0.7}, 
			font = "Friz Quadrata TT", 
			size = 9,
			textymod = 0,
		},
		
		can_change_alpha_head = true, 
		icon_anchor_main = {-1, -5}, 
		icon_anchor_plugins = {-7, -13}, 
		icon_plugins_size = {19, 18},
		
		--anchors:
		icon_point_anchor = {-37, 0},
		left_corner_anchor = {-107, 0},
		right_corner_anchor = {96, 0},

		icon_point_anchor_bottom = {-37, 12},
		left_corner_anchor_bottom = {-107, 0},
		right_corner_anchor_bottom = {96, 0},
		
		icon_on_top = true,
		icon_ignore_alpha = true,
		icon_titletext_position = {5, 4},
		
		--overwrites
		instance_cprops = {
			["color"] = {
				0.3058, -- [1]
				0.3058, -- [2]
				0.3058, -- [3]
				0.8838, -- [4]
			},
			["menu_anchor"] = {
				16, -- [1]
				2, -- [2]
				["side"] = 2,
			},
			["bg_r"] = 0.0941,
			["color_buttons"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["backdrop_texture"] = "Details Ground",
			["row_info"] = {
				["textR_outline"] = false,
				["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
				["textL_outline"] = false,
				["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
				["textR_show_data"] = {
					true, -- [1]
					true, -- [2]
					true, -- [3]
				},
				["textL_enable_custom_text"] = false,
				["fixed_text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["space"] = {
					["right"] = 0,
					["left"] = 0,
					["between"] = 1,
				},
				["texture_background_class_color"] = false,
				["start_after_icon"] = true,
				["font_face_file"] = "Fonts\\ARIALN.TTF",
				["textL_custom_text"] = "{data1}. {data3}{data2}",
				["font_size"] = 16,
				["height"] = 21,
				["texture_file"] = "Interface\\AddOns\\Details\\images\\bar_serenity",
				["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
				["textR_bracket"] = "(",
				["textR_enable_custom_text"] = false,
				["fixed_texture_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
				},
				["textL_show_number"] = true,
				["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
				["texture"] = "Details Serenity",
				["models"] = {
					["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
					["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
					["upper_alpha"] = 0.5,
					["lower_enabled"] = false,
					["lower_alpha"] = 0.1,
					["upper_enabled"] = false,
				},
				["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
				["texture_background"] = "DGround",
				["use_spec_icons"] = true,
				["textR_class_colors"] = false,
				["alpha"] = 1,
				["no_icon"] = false,
				["percent_type"] = 1,
				["fixed_texture_background_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					0.319999992847443, -- [4]
				},
				["font_face"] = "Arial Narrow",
				["texture_class_colors"] = true,
				["backdrop"] = {
					["enabled"] = false,
					["texture"] = "Details BarBorder 2",
					["color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["size"] = 12,
				},
				["fast_ps_update"] = false,
				["textR_separator"] = ",",
				["textL_class_colors"] = false,
			},
			["micro_displays_side"] = 2,
			["strata"] = "LOW",
			["bg_alpha"] = 0.4181,
			["plugins_grow_direction"] = 1,
			["menu_icons"] = {
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				false, -- [6]
				["space"] = -1,
				["shadow"] = false,
			},
			["desaturated_menu"] = false,
			["show_sidebars"] = false,
			["menu_anchor_down"] = {
				16, -- [1]
				-2, -- [2]
			},
			["statusbar_info"] = {
				["alpha"] = 0.77,
				["overlay"] = {
					0.28627, -- [1]
					0.28627, -- [2]
					0.28627, -- [3]
				},
			},
			["hide_icon"] = true,
			["toolbar_side"] = 1,
			["bg_g"] = 0.0941,
			["show_statusbar"] = false,
			["menu_icons_size"] = 0.899999976158142,
			["wallpaper"] = {
				["enabled"] = false,
				["texcoord"] = {
					0, -- [1]
					1, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["overlay"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["anchor"] = "all",
				["height"] = 0,
				["alpha"] = 0.5,
				["width"] = 0,
			},
			["auto_hide_menu"] = {
				["left"] = false,
				["right"] = false,
			},
			["attribute_text"] = {
				["enabled"] = true,
				["shadow"] = false,
				["side"] = 1,
				["text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["custom_text"] = "{name}",
				["text_face"] = "Arial Narrow",
				["anchor"] = {
					-18, -- [1]
					5, -- [2]
				},
				["text_size"] = 11,
				["enable_custom_text"] = false,
			},
			["bg_b"] = 0.0941,
		},
		
		callback = function (skin, instance, just_updating)
			--none
		end,
		
		skin_options = {
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP"], func = reset_tooltip, desc = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"], func = set_tooltip_elvui2, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"]},
		}
		
	})

	_detalhes:InstallSkin ("Serenity", {
		file = [[Interface\AddOns\Details\images\skins\flat_skin.blp]],
		author = "Details!", 
		version = "1.0", 
		site = "unknown", 
		desc = "Light blue, this skin fits on almost all interfaces.\n\nFor ElvUI interfaces, change the window color to black to get an compatible visual.", 
		
		--micro frames
		micro_frames = {
			left = "DETAILS_STATUSBAR_PLUGIN_PATTRIBUTE",
			color = {1, 1, 1, 0.7}, 
			font = "Accidental Presidency", 
			size = 10,
			textymod = 0,
		},
		
		can_change_alpha_head = true, 
		
		icon_anchor_main = {-1, -5}, 
		icon_anchor_plugins = {-7, -13}, 
		icon_plugins_size = {19, 18},
		
		-- the four anchors:
		icon_point_anchor = {-37, 0},
		left_corner_anchor = {-107, 0},
		right_corner_anchor = {96, 0},

		icon_point_anchor_bottom = {-37, 12},
		left_corner_anchor_bottom = {-107, 0},
		right_corner_anchor_bottom = {96, 0},

		icon_on_top = true,
		icon_ignore_alpha = true,
		icon_titletext_position = {1, 2},
		
		instance_cprops = {
			["show_statusbar"] = false,
			["menu_icons_size"] = 0.80,
			["color"] = {
				0.211764705882353, -- [1]
				0.282352941176471, -- [2]
				0.568627450980392, -- [3]
				1, -- [4]
			},
			["menu_anchor"] = {
				17, -- [1]
				-1, -- [2]
				["side"] = 2,
			},
			["bg_r"] = 0,
			["color_buttons"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["bars_sort_direction"] = 1,
			["attribute_text"] = {
				["enabled"] = true,
				["shadow"] = false,
				["side"] = 1,
				["text_size"] = 13,
				["custom_text"] = "{name}",
				["text_face"] = "Accidental Presidency",
				["anchor"] = {
					-17, -- [1]
					1, -- [2]
				},
				["text_color"] = {
					0.976470588235294, -- [1]
					1, -- [2]
					0.988235294117647, -- [3]
					1, -- [4]
				},
				["enable_custom_text"] = false,
				["show_timer"] = true,
			},
			["micro_displays_side"] = 2,
			["auto_hide_menu"] = {
				["left"] = false,
				["right"] = false,
			},
			["desaturated_menu"] = false,
			["plugins_grow_direction"] = 1,
			["menu_icons"] = {
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				false, -- [6]
				["space"] = -1,
				["shadow"] = false,
			},
			["show_sidebars"] = false,
			["grab_on_top"] = false,
			["menu_anchor_down"] = {
				15, -- [1]
				-3, -- [2]
			},
			["backdrop_texture"] = "Details Ground",
			["statusbar_info"] = {
				["alpha"] = 1,
				["overlay"] = {
					0.211764705882353, -- [1]
					0.282352941176471, -- [2]
					0.568627450980392, -- [3]
				},
			},
			["toolbar_side"] = 1,
			["bg_g"] = 0.0509803921568627,
			["bars_grow_direction"] = 1,
			["row_info"] = {
				["textR_outline"] = false,
				["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
				["textL_outline"] = false,
				["textR_outline_small"] = true,
				["textL_outline_small"] = true,
				["textL_enable_custom_text"] = true,
				["fixed_text_color"] = {
					0.956862745098039, -- [1]
					0.980392156862745, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["space"] = {
					["right"] = 0,
					["left"] = 0,
					["between"] = 1,
				},
				["texture_background_class_color"] = false,
				["start_after_icon"] = true,
				["font_face_file"] = "Interface\\Addons\\Details\\fonts\\Accidental Presidency.ttf",
				["textL_custom_text"] = "{data1} - {data3}{data2}",
				["models"] = {
					["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
					["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
					["upper_alpha"] = 0.501719892024994,
					["lower_enabled"] = false,
					["lower_alpha"] = 0.1,
					["upper_enabled"] = false,
				},
				["texture_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
				["textR_bracket"] = "[",
				["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
				["icon_grayscale"] = false,
				["font_size"] = 16,
				["height"] = 21,
				["use_spec_icons"] = true,
				["texture_custom"] = "",
				["backdrop"] = {
					["enabled"] = false,
					["texture"] = "Details BarBorder 2",
					["color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["size"] = 1,
				},
				["fixed_texture_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["textL_show_number"] = true,
				["fixed_texture_background_color"] = {
					0, -- [1]
					0.0862745098039216, -- [2]
					0.180392156862745, -- [3]
					0.350894033908844, -- [4]
				},
				["textL_outline_small_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
				["texture"] = "DGround",
				["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
				["textR_show_data"] = {
					true, -- [1]
					true, -- [2]
					false, -- [3]
				},
				["textL_class_colors"] = false,
				["textR_class_colors"] = false,
				["textR_outline_small_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["texture_background"] = "Details D'ictum",
				["alpha"] = 1,
				["no_icon"] = false,
				["textR_enable_custom_text"] = false,
				["percent_type"] = 1,
				["font_face"] = "Accidental Presidency",
				["texture_class_colors"] = true,
				["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar4",
				["fast_ps_update"] = false,
				["textR_separator"] = "NONE",
				["texture_custom_file"] = "Interface\\",
			},
			["bg_alpha"] = 0.0216164588928223,
			["wallpaper"] = {
				["enabled"] = false,
				["width"] = 266.000061035156,
				["texcoord"] = {
					0.0480000019073486, -- [1]
					0.298000011444092, -- [2]
					0.630999984741211, -- [3]
					0.755999984741211, -- [4]
				},
				["overlay"] = {
					0.999997794628143, -- [1]
					0.999997794628143, -- [2]
					0.999997794628143, -- [3]
					0.266666084527969, -- [4]
				},
				["anchor"] = "all",
				["height"] = 225.999984741211,
				["alpha"] = 0.266666680574417,
				["texture"] = "Interface\\AddOns\\Details\\images\\skins\\elvui",
			},
			["stretch_button_side"] = 1,
			["hide_icon"] = true,
			["bg_b"] = 0.454901960784314,
 		},
		
		skin_options = {
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP"], func = reset_tooltip, desc = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"], func = set_tooltip_elvui2, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"]},
		}
	})
	
	local align_right_chat = function()
	
		if (not RightChatPanel or not RightChatPanel:IsShown()) then
			_detalhes:Msg ("Right Chat Panel isn't shown.")
			return
		end
		
		local wight, height = RightChatPanel:GetSize()
	
		local instance1 = _detalhes.tabela_instancias [1]
		local instance2 = _detalhes.tabela_instancias [2]
		local instance3 = _detalhes.tabela_instancias [3]

		if (not instance2) then
			instance2 = _detalhes:CriarInstancia()
			instance2:ChangeSkin (instance1.skin)
		elseif (not instance2.ativa) then
			instance2:AtivarInstancia()
			instance2:ChangeSkin (instance1.skin)
		end
		
		if (instance3 and instance3:IsEnabled() and instance3.baseframe) then
			instance3:ShutDown()
		end
	
		instance1:UngroupInstance()
		instance2:UngroupInstance()
	
		instance1.baseframe:ClearAllPoints()
		instance2.baseframe:ClearAllPoints()

		local statusbar_enabled1 = instance1.show_statusbar
		local statusbar_enabled2 = instance2.show_statusbar
		
		local ElvUIRightChatDataPanel = RightChatDataPanel and RightChatDataPanel:IsShown()
		
		if (instance1.skin == "Forced Square") then
			instance1.baseframe:SetSize (wight/2 - 4, height-20 - (ElvUIRightChatDataPanel and 21 or 0) - 8 - (statusbar_enabled1 and 14 or 0))
			instance2.baseframe:SetSize (wight/2 - 4 + 2, height-20 - (ElvUIRightChatDataPanel and 21 or 0) - 8 - (statusbar_enabled2 and 14 or 0))
			
		elseif (instance1.skin == "ElvUI Frame Style") then
			instance1.baseframe:SetSize (wight/2 - 4, height-20 - (ElvUIRightChatDataPanel and 21 or 0) - 8 - (statusbar_enabled1 and 14 or 0))
			instance2.baseframe:SetSize (wight/2 - 4, height-20 - (ElvUIRightChatDataPanel and 21 or 0) - 8 - (statusbar_enabled2 and 14 or 0))
			
		elseif (instance1.skin == "ElvUI Style II") then
			instance1.baseframe:SetSize (wight/2 - 4 - 2, height - 20 - 2 - (ElvUIRightChatDataPanel and 21 or 0) - 8 - (statusbar_enabled1 and 14 or 0))
			instance2.baseframe:SetSize (wight/2 - 4 - 2, height - 20 - 2 - (ElvUIRightChatDataPanel and 21 or 0) - 8 - (statusbar_enabled2 and 14 or 0))
			
		else
			instance1.baseframe:SetSize (wight/2 - 4, height-20 - (ElvUIRightChatDataPanel and 21 or 0) - 8 - (statusbar_enabled1 and 14 or 0))
			instance2.baseframe:SetSize (wight/2 - 4, height-20 - (ElvUIRightChatDataPanel and 21 or 0) - 8 - (statusbar_enabled2 and 14 or 0))
			
		end

		table.wipe (instance1.snap); table.wipe (instance2.snap)
		instance1.snap [3] = 2; instance2.snap [1] = 1;
		instance1.horizontalSnap = true; instance2.horizontalSnap = true
		
		instance1.baseframe:SetPoint ("bottomleft", RightChatDataPanel, "topleft", 1 - (instance1.skin == "Forced Square" and 1 or 0), 1 + (statusbar_enabled1 and 14 or 0) - (ElvUIRightChatDataPanel and 0 or 22))
		instance2.baseframe:SetPoint ("bottomright", RightChatToggleButton, "topright", -1, 1 + (statusbar_enabled2 and 14 or 0) - (ElvUIRightChatDataPanel and 0 or 22))
	
		instance1:LockInstance (true)
		instance2:LockInstance (true)
	
		instance1:SaveMainWindowPosition()
		instance2:SaveMainWindowPosition()

		_detalhes.move_janela_func (instance1.baseframe, true, instance1)
		_detalhes.move_janela_func (instance1.baseframe, false, instance1)
		_detalhes.move_janela_func (instance2.baseframe, true, instance2)
		_detalhes.move_janela_func (instance2.baseframe, false, instance2)
		
	end
	
	_detalhes:InstallSkin ("Forced Square", {
		file = [[Interface\AddOns\Details\images\skins\simplygray_skin.blp]],
		author = "Details!", 
		version = "1.0", 
		site = "unknown", 
		desc = "Very clean skin without textures and only with a black contour.", 
		
		--general
		can_change_alpha_head = true, 

		--icon anchors
		icon_anchor_main = {-1, -5},
		icon_anchor_plugins = {-7, -13},
		icon_plugins_size = {19, 18},
		
		--micro frames
		micro_frames = {
			color = {.7, .7, .7, 0.7},
			font = "FORCED SQUARE", 
			size = 10,
			textymod = 1,
		},		

		-- the four anchors (for when the toolbar is on the top side)
		icon_point_anchor = {-37, 0},
		left_corner_anchor = {-107, 0},
		right_corner_anchor = {96, 0},
		
		-- the four anchors (for when the toolbar is on the bottom side)
		icon_point_anchor_bottom = {-37, 12},
		left_corner_anchor_bottom = {-107, 0},
		right_corner_anchor_bottom = {96, 0},

		--[[ callback function execute after all changes on the window, first argument is this skin table, second is the instance where the skin was applied --]]
		callback = function (self, instance) end,
		--[[ control_script is a OnUpdate script, it start right after all changes on the window and also after the callback --]]
		--[[ control_script_on_start run before the control_script, use it to reset values if needed --]]
		control_script_on_start = nil,
		control_script = nil,
		
		icon_ignore_alpha = true,
		icon_titletext_position = {3, 4},
		
		--instance overwrites
		--[[ when a skin is selected, all customized properties of the window is reseted and then the overwrites are applied]]
		--[[ for the complete cprop list see the file classe_instancia_include.lua]]
		instance_cprops = {
			["hide_in_combat_type"] = 1,
			["color"] = {
				0,
				0,
				0,
				1,
			},
			["menu_anchor"] = {
				14,
				2,
				["side"] = 2,
			},
			["menu_anchor_down"] = {
				14,
				-2,
			},
			["bg_r"] = 0,
			["following"] = {
				["enabled"] = false,
				["bar_color"] = {
					1,
					1,
					1,
				},
				["text_color"] = {
					1,
					1,
					1,
				},
			},
			["color_buttons"] = {
				1,
				1,
				1,
				1,
			},
			["bars_sort_direction"] = 1,
			["instance_button_anchor"] = {
				-27,
				1,
			},
			["name"] = "new simple gray 2",
			["attribute_text"] = {
				["enabled"] = true,
				["shadow"] = true,
				["side"] = 1,
				["text_color"] = {
					0.768627450980392,
					0.768627450980392,
					0.768627450980392,
					1,
				},
				["custom_text"] = "{name}",
				["text_face"] = "FORCED SQUARE",
				["anchor"] = {
					-15,
					5,
				},
				["text_size"] = 12,
				["enable_custom_text"] = false,
			},
			["switch_damager_in_combat"] = false,
			["menu_alpha"] = {
				["enabled"] = false,
				["onleave"] = 1,
				["ignorebars"] = false,
				["iconstoo"] = true,
				["onenter"] = 1,
			},
			["total_bar"] = {
				["enabled"] = false,
				["only_in_group"] = true,
				["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
				["color"] = {
					1,
					1,
					1,
				},
			},
			["micro_displays_side"] = 2,
			["plugins_grow_direction"] = 1,
			["menu_icons"] = {
				true,
				true,
				true,
				true,
				true, -- [5]
				false, -- [6]
				["space"] = -1,
				["shadow"] = true,
			},
			["desaturated_menu"] = false,
			["show_sidebars"] = true,
			["statusbar_info"] = {
				["alpha"] = 1,
				["overlay"] = {
					0,
					0,
					0,
				},
			},
			["window_scale"] = 1,
			["auto_hide_menu"] = {
				["left"] = false,
				["right"] = false,
			},
			["hide_icon"] = true,
			["row_info"] = {
				["textR_outline"] = false,
				["textL_outline"] = false,
				["fixed_texture_color"] = {
					0,
					0,
					0,
				},
				["use_spec_icons"] = true,
				["icon_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal_alpha",
				["textL_show_number"] = true,
				["texture"] = "Skyline",
				["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar4",
				["textR_enable_custom_text"] = false,
				["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
				["textL_enable_custom_text"] = false,
				["fixed_text_color"] = {
					1,
					1,
					1,
				},
				["space"] = {
					["right"] = -10,
					["left"] = 5,
					["between"] = 1,
				},
				["fixed_texture_background_color"] = {
					0,
					0,
					0,
					0.2,
				},
				["texture_background_class_color"] = false,
				["start_after_icon"] = false,
				["font_face_file"] = "Interface\\Addons\\Details\\fonts\\FORCED SQUARE.ttf",
				["backdrop"] = {
					["enabled"] = false,
					["size"] = 12,
					["color"] = {
						1,
						1,
						1,
						1,
					},
					["texture"] = "Details BarBorder 2",
				},
				["textL_class_colors"] = false,
				["models"] = {
					["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
					["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
					["upper_alpha"] = 0.5,
					["lower_enabled"] = false,
					["lower_alpha"] = 0.1,
					["upper_enabled"] = false,
				},
				["textL_custom_text"] = "{data1}. {data3}{data2}",
				["textR_class_colors"] = false,
				["alpha"] = 1,
				["no_icon"] = false,
				["font_size"] = 16,
				["height"] = 21,
				["texture_background"] = "Details Serenity",
				["font_face"] = "FORCED SQUARE",
				["texture_class_colors"] = true,
				["texture_file"] = "Interface\\AddOns\\Details\\images\\bar4",
				["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
				["percent_type"] = 1,
			},
			["toolbar_side"] = 1,
			["bg_g"] = 0,
			["bars_grow_direction"] = 1,
			["backdrop_texture"] = "Details Ground",
			["show_statusbar"] = false,
			["menu_icons_size"] = 0.899999976158142,
			["wallpaper"] = {
				["enabled"] = false,
				["width"] = 265.999943487933,
				["texcoord"] = {
					0.342000007629395,
					0.00100000001490116,
					1,
					0.573999977111816,
				},
				["overlay"] = {
					0,
					0,
					0,
					0.807841360569,
				},
				["anchor"] = "all",
				["height"] = 226.000007591173,
				["alpha"] = 0.807843208312988,
				["texture"] = "Interface\\Glues\\CREDITS\\Fellwood5",
			},
			["bg_alpha"] = 0.0491309501230717,
			["bg_b"] = 0,
		},
		
		skin_options = {
			{spacement = true, type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON1"], func = align_right_chat, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON1_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP"], func = reset_tooltip, desc = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"], func = set_tooltip_elvui2, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"]},
		}
		
	})
		
	_detalhes:InstallSkin ("ElvUI Frame Style", {
		file = [[Interface\AddOns\Details\images\skins\elvui.blp]],
		author = "Details!", 
		version = "1.0", 
		site = "unknown", 
		desc = "This skin is based on ElvUI's addons, relying with black and transparent frames.", 
		
		--general
		can_change_alpha_head = true, 

		--icon anchors
		icon_anchor_main = {-4, -5},
		icon_anchor_plugins = {-7, -13},
		icon_plugins_size = {19, 18},

		--micro frames
		micro_frames = {
			color = {1, 1, 1, 0.7},
			font = "FORCED SQUARE", 
			size = 10,
			textymod = 1,
		},
		
		-- the four anchors (for when the toolbar is on the top side)
		icon_point_anchor = {-35, -0.5},
		left_corner_anchor = {-107, 0},
		right_corner_anchor = {96, 0},
		
		-- the four anchors (for when the toolbar is on the bottom side)
		icon_point_anchor_bottom = {-37, 12},
		left_corner_anchor_bottom = {-107, 0},
		right_corner_anchor_bottom = {96, 0},

		--[[ callback function execute after all changes on the window, first argument is this skin table, second is the instance where the skin was applied --]]
		callback = function (self, instance) end,
		--[[ control_script is a OnUpdate script, it start right after all changes on the window and also after the callback --]]
		--[[ control_script_on_start run before the control_script, use it to reset values if needed --]]
		control_script_on_start = nil,
		control_script = nil,
		
		--instance overwrites
		--[[ when a skin is selected, all customized properties of the window is reseted and then the overwrites are applied]]
		--[[ for the complete cprop list see the file classe_instancia_include.lua]]
		
		icon_on_top = true,
		icon_ignore_alpha = true,
		icon_titletext_position = {2, 5},
		
		instance_cprops = {
			["menu_icons_size"] = 0.899999976158142,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["menu_anchor"] = {
				16, -- [1]
				2, -- [2]
				["side"] = 2,
			},
			["bg_r"] = 0.3294,
			["following"] = {
				["bar_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["enabled"] = true,
				["text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
			},
			["color_buttons"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["bars_sort_direction"] = 1,
			["attribute_text"] = {
				["enabled"] = true,
				["shadow"] = true,
				["side"] = 1,
				["text_size"] = 12,
				["custom_text"] = "{name}",
				["text_face"] = "FORCED SQUARE",
				["anchor"] = {
					-19, -- [1]
					5, -- [2]
				},
				["text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					0.7, -- [4]
				},
				["enable_custom_text"] = false,
			},
			["row_info"] = {
				["textR_outline"] = false,
				["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
				["textL_outline"] = false,
				["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
				["textR_show_data"] = {
					true, -- [1]
					true, -- [2]
					true, -- [3]
				},
				["textL_enable_custom_text"] = false,
				["fixed_text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["space"] = {
					["right"] = -2,
					["left"] = 1,
					["between"] = 1,
				},
				["texture_background_class_color"] = false,
				["start_after_icon"] = true,
				["font_face_file"] = "Interface\\Addons\\Details\\fonts\\FORCED SQUARE.ttf",
				["textL_custom_text"] = "{data1}. {data3}{data2}",
				["font_size"] = 16,
				["height"] = 21,
				["texture_file"] = "Interface\\AddOns\\Details\\images\\bar4",
				["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
				["textR_bracket"] = "[",
				["textR_enable_custom_text"] = false,
				["fixed_texture_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
				},
				["textL_show_number"] = true,
				["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
				["texture"] = "Skyline",
				["use_spec_icons"] = true,
				["textR_class_colors"] = false,
				["textL_class_colors"] = false,
				["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
				["texture_background"] = "DGround",
				["alpha"] = 0.8,
				["no_icon"] = false,
				["percent_type"] = 1,
				["fixed_texture_background_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					0.339636147022247, -- [4]
				},
				["font_face"] = "FORCED SQUARE",
				["texture_class_colors"] = true,
				["models"] = {
					["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
					["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
					["upper_alpha"] = 0.5,
					["lower_enabled"] = false,
					["lower_alpha"] = 0.1,
					["upper_enabled"] = false,
				},
				["fast_ps_update"] = false,
				["textR_separator"] = "|",
				["backdrop"] = {
					["enabled"] = false,
					["size"] = 4,
					["color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
					["texture"] = "Details BarBorder 2",
				},
			},
			
			["show_sidebars_need_resize_by"] = 1,
			
			["auto_hide_menu"] = {
				["left"] = false,
				["right"] = false,
			},
			["desaturated_menu"] = false,
			["plugins_grow_direction"] = 1,
			["menu_icons"] = {
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				false, -- [6]
				["space"] = -1,
				["shadow"] = true,
			},
			["show_sidebars"] = true,
			["bars_grow_direction"] = 1,
			["menu_anchor_down"] = {
				16, -- [1]
				-2, -- [2]
			},
			["backdrop_texture"] = "Details Ground",
			["statusbar_info"] = {
				["alpha"] = 1,
				["overlay"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
			},
			["toolbar_side"] = 1,
			["bg_g"] = 0.3294,
			["micro_displays_side"] = 2,
			["bg_alpha"] = 0.51,
			["show_statusbar"] = false,
			["wallpaper"] = {
				["enabled"] = true,
				["texture"] = "Interface\\AddOns\\Details\\images\\skins\\elvui",
				["texcoord"] = {
					0.0480000019073486, -- [1]
					0.298000011444092, -- [2]
					0.630999984741211, -- [3]
					0.755999984741211, -- [4]
				},
				["overlay"] = {
					0.999997794628143, -- [1]
					0.999997794628143, -- [2]
					0.999997794628143, -- [3]
					0.799998223781586, -- [4]
				},
				["anchor"] = "all",
				["height"] = 225.999984741211,
				["alpha"] = 0.800000071525574,
				["width"] = 266.000061035156,
			},
			["stretch_button_side"] = 1,
			["hide_icon"] = true,
			["bg_b"] = 0.3294,
		},
		
		skin_options = {
			{spacement = true, type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON1"], func = align_right_chat, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON1_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON2"], func = set_tooltip_elvui1, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON2_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"], func = set_tooltip_elvui2, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"]},
		}
	})
	
	_detalhes:InstallSkin ("ElvUI Style II", {
		file = [[Interface\AddOns\Details\images\skins\elvui_opaque.blp]],
		author = "Details!", 
		version = "1.0", 
		site = "unknown", 
		desc = "based on AddonSkins for ElvUI, this skin has opaque title bar and background.", 
		
		--general
		can_change_alpha_head = true, 

		--icon anchors
		icon_anchor_main = {-4, -5},
		icon_anchor_plugins = {-7, -13},
		icon_plugins_size = {19, 18},
		
		--micro frames
		micro_frames = {
			color = {0.525490, 0.525490, 0.525490, 1}, 
			font = "FORCED SQUARE", 
			size = 11,
			textymod = 1,
		},
		
		-- the four anchors (for when the toolbar is on the top side)
		icon_point_anchor = {-35, -0.5},
		left_corner_anchor = {-107, 0},
		right_corner_anchor = {96, 0},
		
		-- the four anchors (for when the toolbar is on the bottom side)
		icon_point_anchor_bottom = {-37, 12},
		left_corner_anchor_bottom = {-107, 0},
		right_corner_anchor_bottom = {96, 0},

		--[[ callback function execute after all changes on the window, first argument is this skin table, second is the instance where the skin was applied --]]
		callback = function (self, instance) end,
		--[[ control_script is a OnUpdate script, it start right after all changes on the window and also after the callback --]]
		--[[ control_script_on_start run before the control_script, use it to reset values if needed --]]
		control_script_on_start = nil,
		control_script = nil,
		
		--instance overwrites
		--[[ when a skin is selected, all customized properties of the window is reseted and then the overwrites are applied]]
		--[[ for the complete cprop list see the file classe_instancia_include.lua]]
		
		icon_on_top = true,
		icon_ignore_alpha = true,
		icon_titletext_position = {2, 5},
		
		instance_cprops = {
			["show_statusbar"] = false,
			["color"] = {1,1,1,1},
			["menu_anchor"] = {17, 2, ["side"] = 2},
			["bg_r"] = 0.517647058823529,
			["color_buttons"] = {1,1,1,1},
			["bars_sort_direction"] = 1,
			["instance_button_anchor"] = {-27,1},
			["row_info"] = {
				["textR_outline"] = false,
				["textL_outline"] = false,
				["use_spec_icons"] = true,
				["textL_enable_custom_text"] = false,
				["icon_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
				["texture_background_file"] = "Interface\\AddOns\\Details\\images\\BantoBar",
				["start_after_icon"] = true,
				["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
				["textR_enable_custom_text"] = false,
				["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
				["percent_type"] = 1,
				["fixed_text_color"] = {0.905882352941177,0.905882352941177,0.905882352941177,1},
				["space"] = {
					["right"] = -3,
					["right_noborder"] = -3,
					["left"] = 1,
					["left_noborder"] = 1,
					["between"] = 1,
				},
				["texture"] = "DGround",
				["texture_background_class_color"] = false,
				["fixed_texture_background_color"] = {0,0,0,0.295484036207199},
				["font_face_file"] = "Fonts\\ARIALN.TTF",
				["alpha"] = 1,
				["textR_class_colors"] = false,
				["models"] = {
					["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
					["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
					["upper_alpha"] = 0.5,
					["lower_enabled"] = false,
					["lower_alpha"] = 0.1,
					["upper_enabled"] = false,
				},
				["backdrop"] = {
					["enabled"] = false,
					["size"] = 5,
					["color"] = {0, 0, 0, 1},
					["texture"] = "Details BarBorder 1",
				},
				["texture_background"] = "BantoBar",
				["textL_custom_text"] = "{data1}. {data3}{data2}",
				["no_icon"] = false,
				["font_size"] = 16,
				["height"] = 21,
				["textL_class_colors"] = false,
				["font_face"] = "FORCED SQUARE",
				["texture_class_colors"] = true,
				["texture_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
				["textL_show_number"] = true,
				["fixed_texture_color"] = {0.862745098039216,0.862745098039216,0.862745098039216,1},
			},
			["bars_grow_direction"] = 1,
			["menu_alpha"] = {
				["enabled"] = false,
				["onleave"] = 1,
				["ignorebars"] = false,
				["iconstoo"] = true,
				["onenter"] = 1,
			},
			["total_bar"] = {
				["enabled"] = false,
				["only_in_group"] = true,
				["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
				["color"] = {1,1,1},
			},
			["plugins_grow_direction"] = 1,
			["strata"] = "LOW",
			["show_sidebars"] = true,
			["show_sidebars_need_resize_by"] = 1,
			["hide_in_combat_alpha"] = 0,
			["menu_icons"] = {true, true, true, true, true, false, ["space"] = -1, ["shadow"] = true},
			["desaturated_menu"] = false,
			["auto_hide_menu"] = {
				["left"] = false,
				["right"] = false,
			},
			["window_scale"] = 1.0,
			["grab_on_top"] = false,
			["menu_anchor_down"] = {16, -2},
			["statusbar_info"] = {
				["alpha"] = 1,
				["overlay"] = {1,1,1},
			},
			["hide_icon"] = true,
			["micro_displays_side"] = 2,
			["bg_alpha"] = 1,
			["auto_current"] = true,
			["toolbar_side"] = 1,
			["bg_g"] = 0.517647058823529,
			["backdrop_texture"] = "Details Ground",
			["hide_in_combat"] = false,
			["skin"] = "ElvUI Style II",
			["menu_icons_size"] = 0.850000023841858,
			["wallpaper"] = {
				["enabled"] = true,
				["width"] = 265.999979475717,
				["texcoord"] = {0.0480000019073486,0.298000011444092,0.630999984741211,0.755999984741211},
				["overlay"] = {0.999997794628143,0.999997794628143,0.999997794628143,0.799998223781586},
				["anchor"] = "all",
				["height"] = 226.000007591173,
				["alpha"] = 0.800000071525574,
				["texture"] = "Interface\\AddOns\\Details\\images\\skins\\elvui",
			},
			["stretch_button_side"] = 1,
			["attribute_text"] = {
				["enabled"] = true,
				["shadow"] = true,
				["side"] = 1,
				["enable_custom_text"] = false,
				["custom_text"] = "{name}",
				["text_face"] = "FORCED SQUARE",
				["anchor"] = {-18, 5},
				["text_color"] = {1,1,1,0.7},
				["text_size"] = 12,
			},
			["bg_b"] = 0.517647058823529,
		},
		
		skin_options = {
			{spacement = true, type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON1"], func = align_right_chat, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON1_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON2"], func = set_tooltip_elvui1, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON2_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"], func = set_tooltip_elvui2, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"]},
		}
	})
	
	_detalhes:InstallSkin ("Dark Theme", {
		file = [[Interface\AddOns\Details\images\skins\darktheme.blp]],
		author = "Details!",
		version = "1.0",
		site = "unknown",
		desc = "Regular Details! skin but with a dark theme.",
		
		--general
		can_change_alpha_head = true,

		--icon anchors
		icon_anchor_main = {-4, -5},
		icon_anchor_plugins = {-7, -13},
		icon_plugins_size = {19, 18},

		--micro frames
		micro_frames = {
			color = {1, 1, 1, 0.7},
			font = "Oswald",
			size = 9,
			textymod = 0,
			["left"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT",
			["center"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
			["right"] = "DETAILS_STATUSBAR_PLUGIN_PDURABILITY",
		},

		
		-- the four anchors (for when the toolbar is on the top side)
		icon_point_anchor = {-35, -0.5},
		left_corner_anchor = {-106, 0},
		right_corner_anchor = {95, 0},
		
		-- the four anchors (for when the toolbar is on the bottom side)
		icon_point_anchor_bottom = {-37, 12},
		left_corner_anchor_bottom = {-106, 0},
		right_corner_anchor_bottom = {95, 0},

		--[[ callback function execute after all changes on the window, first argument is this skin table, second is the instance where the skin was applied --]]
		callback = function (self, instance) end,
		--[[ control_script is a OnUpdate script, it start right after all changes on the window and also after the callback --]]
		--[[ control_script_on_start run before the control_script, use it to reset values if needed --]]
		control_script_on_start = nil,
		control_script = nil,
		
		--instance overwrites
		--[[ when a skin is selected, all customized properties of the window is reseted and then the overwrites are applied]]
		--[[ for the complete cprop list see the file classe_instancia_include.lua]]
		
		icon_on_top = true,
		icon_ignore_alpha = true,
		icon_titletext_position = {1, 2},
		
		instance_cprops = {
			["hide_in_combat_type"] = 1,
			["fontstrings_text3_anchor"] = 37,
			["menu_anchor"] = {
				19, -- [1]
				1, -- [2]
				["side"] = 2,
			},
			["bg_r"] = 0.32941176470588,
			["hide_out_of_combat"] = false,
			["color_buttons"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["toolbar_icon_file"] = "Interface\\AddOns\\Details\\images\\toolbar_icons_2",
			["bars_sort_direction"] = 1,
			["fontstrings_width"] = 35,
			["tooltip"] = {
				["n_abilities"] = 3,
				["n_enemies"] = 3,
			},
			["switch_all_roles_in_combat"] = false,
			["clickthrough_toolbaricons"] = false,
			["row_info"] = {
				["textR_outline"] = false,
				["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
				["textL_outline"] = false,
				["textR_outline_small"] = true,
				["textL_outline_small"] = true,
				["textL_enable_custom_text"] = false,
				["fixed_text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["space"] = {
					["right"] = 0,
					["left"] = 0,
					["between"] = 1,
				},
				["texture_background_class_color"] = false,
				["textL_outline_small_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["font_face_file"] = "Interface\\Addons\\Details\\fonts\\Oswald-Regular.otf",
				["backdrop"] = {
					["enabled"] = false,
					["texture"] = "Details BarBorder 2",
					["color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
					["size"] = 4,
				},
				["font_size"] = 12,
				["textL_translit_text"] = false,
				["height"] = 21,
				["texture_file"] = "Interface\\AddOns\\Details\\images\\bar_textures\\texture2020.blp",
				["use_spec_icons"] = true,
				["models"] = {
					["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
					["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
					["upper_alpha"] = 0.5,
					["lower_enabled"] = false,
					["lower_alpha"] = 0.1,
					["upper_enabled"] = false,
				},
				["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
				["icon_grayscale"] = false,
				["textL_custom_text"] = "{data1}. {data3}{data2}",
				["textR_bracket"] = "[",
				["textR_enable_custom_text"] = false,
				["percent_type"] = 1,
				["fixed_texture_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
				},
				["textL_show_number"] = true,
				["texture_custom"] = "",
				["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
				["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
				["texture"] = "Details2020",
				["start_after_icon"] = true,
				["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
				["textR_class_colors"] = false,
				["alpha"] = 0.8,
				["textL_class_colors"] = false,
				["texture_background"] = "Details Flat",
				["textR_outline_small_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["no_icon"] = false,
				["icon_offset"] = {
					0, -- [1]
					0, -- [2]
				},
				["fixed_texture_background_color"] = {
					0.1843137254902, -- [1]
					0.1921568627451, -- [2]
					0.18823529411765, -- [3]
					0.41242814064026, -- [4]
				},
				["font_face"] = "Oswald",
				["texture_class_colors"] = true,
				["textR_show_data"] = {
					true, -- [1]
					true, -- [2]
					false, -- [3]
				},
				["fast_ps_update"] = false,
				["textR_separator"] = ",",
				["texture_custom_file"] = "Interface\\AddOns\\Details\\images\\bar_textures\\texture2020.blp",
			},
			["switch_tank"] = false,
			["plugins_grow_direction"] = 1,
			["menu_icons"] = {
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				false, -- [6]
				["space"] = -2,
				["shadow"] = false,
			},
			["desaturated_menu"] = false,
			["micro_displays_side"] = 2,
			["window_scale"] = 1,
			["hide_icon"] = false,
			["toolbar_side"] = 1,
			["bg_g"] = 0.32941176470588,
			["bg_b"] = 0.32941176470588,
			["switch_healer_in_combat"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["hide_on_context"] = {
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [1]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [2]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [3]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [4]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [5]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [6]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [7]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [8]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [9]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [10]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [11]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [12]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [13]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [14]
				{
					["enabled"] = false,
					["inverse"] = false,
					["value"] = 100,
				}, -- [15]
			},
			["following"] = {
				["enabled"] = false,
				["bar_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
			},
			["switch_healer"] = false,
			["fontstrings_text2_anchor"] = 74,
			["StatusBarSaved"] = {
				["center"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
				["right"] = "DETAILS_STATUSBAR_PLUGIN_PDURABILITY",
				["options"] = {
					["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
						["textColor"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							0.7, -- [4]
						},
						["textFace"] = "Oswald",
						["textXMod"] = 0,
						["timeType"] = 1,
						["textStyle"] = 2,
						["textSize"] = 9,
						["textYMod"] = 0.5605735778808594,
					},
					["DETAILS_STATUSBAR_PLUGIN_PSEGMENT"] = {
						["isHidden"] = false,
						["textStyle"] = 2,
						["textYMod"] = 0.5605735778808594,
						["segmentType"] = 2,
						["textFace"] = "Oswald",
						["textXMod"] = -4,
						["textSize"] = 9,
						["textColor"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							0.7, -- [4]
						},
					},
					["DETAILS_STATUSBAR_PLUGIN_PDURABILITY"] = {
						["isHidden"] = false,
						["textColor"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							0.7, -- [4]
						},
						["textXMod"] = 5,
						["textFace"] = "Oswald",
						["textStyle"] = 2,
						["textSize"] = 9,
						["textYMod"] = -1,
					},
				},
				["left"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT",
			},
			["grab_on_top"] = false,
			["__was_opened"] = true,
			["instance_button_anchor"] = {
				-27, -- [1]
				1, -- [2]
			},
			["version"] = 3,
			["fontstrings_text4_anchor"] = 0,
			["__locked"] = false,
			["menu_alpha"] = {
				["enabled"] = false,
				["onenter"] = 1,
				["iconstoo"] = true,
				["ignorebars"] = false,
				["onleave"] = 1,
			},
			["auto_hide_menu"] = {
				["left"] = false,
				["right"] = false,
			},
			["stretch_button_side"] = 1,
			["show_sidebars"] = false,
			["strata"] = "LOW",
			["clickthrough_incombatonly"] = true,
			["__snap"] = {
			},
			["backdrop_texture"] = "Details Ground",
			["hide_in_combat_alpha"] = 0,
			["menu_icons_size"] = 0.8999999761581421,
			["show_statusbar"] = true,
			["libwindow"] = {
				["y"] = -155.9998626708984,
				["x"] = -372.999755859375,
				["point"] = "RIGHT",
				["scale"] = 1,
			},
			["statusbar_info"] = {
				["alpha"] = 1,
				["overlay"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
			},
			["clickthrough_window"] = false,
			["bars_grow_direction"] = 1,
			["bg_alpha"] = 0.51000002026558,
			["switch_tank_in_combat"] = false,
			["bars_inverted"] = false,
			["switch_damager_in_combat"] = false,
			["micro_displays_locked"] = true,
			["icon_desaturated"] = false,
			["auto_current"] = true,
			["menu_anchor_down"] = {
				16, -- [1]
				-2, -- [2]
			},
			["clickthrough_rows"] = false,
			["attribute_text"] = {
				["enabled"] = true,
				["shadow"] = false,
				["side"] = 1,
				["text_size"] = 12,
				["custom_text"] = "{name}",
				["text_face"] = "Oswald",
				["anchor"] = {
					1, -- [1]
					2, -- [2]
				},
				["show_timer"] = true,
				["enable_custom_text"] = false,
				["text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					0.69272297620773, -- [4]
				},
			},
			["hide_in_combat"] = false,
			["posicao"] = {
				["normal"] = {
					["y"] = -155.9998779296875,
					["x"] = 431.5001220703125,
					["w"] = 311.000244140625,
					["h"] = 154.0000610351563,
				},
				["solo"] = {
					["y"] = 2,
					["x"] = 1,
					["w"] = 300,
					["h"] = 200,
				},
			},
			["skin_custom"] = "",
			["switch_damager"] = false,
			["wallpaper"] = {
				["enabled"] = true,
				["width"] = 266,
				["texcoord"] = {
					0.048000001907349, -- [1]
					0.29800001144409, -- [2]
					0.63099998474121, -- [3]
					0.75599998474121, -- [4]
				},
				["overlay"] = {
					0.99999779462814, -- [1]
					0.99999779462814, -- [2]
					0.99999779462814, -- [3]
					0.79999822378159, -- [4]
				},
				["anchor"] = "all",
				["height"] = 226.00001525879,
				["alpha"] = 0.80000007152557,
				["texture"] = "Interface\\AddOns\\Details\\images\\skins\\darktheme",
			},
			["total_bar"] = {
				["enabled"] = false,
				["only_in_group"] = true,
				["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
				["color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
			},
			["switch_all_roles_after_wipe"] = false,
			["ignore_mass_showhide"] = false,
			["use_multi_fontstrings"] = true,
			["row_show_animation"] = {
				["anim"] = "Fade",
				["options"] = {
				},
			},
			["skin"] = "Dark Theme",
		},
		
		skin_options = {
			{spacement = true, type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON1"], func = align_right_chat, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON1_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON2"], func = set_tooltip_elvui1, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON2_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"], func = set_tooltip_elvui2, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"]},
		}
	})

	_detalhes:InstallSkin ("New Gray", {
		file = [[Interface\AddOns\Details\images\skins\classic_skin_v1.blp]],
		author = "Details!", 
		version = "1.0", 
		site = "unknown", 
		desc = "Simple skin with soft gray color and half transparent frames.", --\n
		
		--micro frames
		micro_frames = {
			color = {1, 1, 1, 1}, 
			font = "Accidental Presidency", 
			size = 10,
			textymod = 1,
		},
		
		can_change_alpha_head = true, 
		icon_anchor_main = {-1, -5}, 
		icon_anchor_plugins = {-7, -13}, 
		icon_plugins_size = {19, 18},
		
		--anchors:
		icon_point_anchor = {-37, 0},
		left_corner_anchor = {-107, 0},
		right_corner_anchor = {96, 0},

		icon_point_anchor_bottom = {-37, 12},
		left_corner_anchor_bottom = {-107, 0},
		right_corner_anchor_bottom = {96, 0},
		
		icon_on_top = true,
		icon_ignore_alpha = true,
		icon_titletext_position = {3, 3},
		
		--overwrites
		instance_cprops = {
			["show_statusbar"] = false,
			["menu_icons_size"] = 0.850000023841858,
			["color"] = {
				0.447058823529412, -- [1]
				0.447058823529412, -- [2]
				0.447058823529412, -- [3]
				0.131542265415192, -- [4]
			},
			["menu_anchor"] = {
				16, -- [1]
				0, -- [2]
				["side"] = 2,
			},
			["bg_r"] = 0.0941176470588235,
			["color_buttons"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["bars_sort_direction"] = 1,
			["row_show_animation"] = {
				["anim"] = "Fade",
				["options"] = {
				},
			},
			["total_bar"] = {
				["enabled"] = false,
				["only_in_group"] = true,
				["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
				["color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
			},
			["attribute_text"] = {
				["enabled"] = true,
				["shadow"] = false,
				["side"] = 1,
				["text_color"] = {
					0.933333333333333, -- [1]
					0.933333333333333, -- [2]
					0.933333333333333, -- [3]
					1, -- [4]
				},
				["custom_text"] = "{name}",
				["text_face"] = "Accidental Presidency",
				["anchor"] = {
					-18, -- [1]
					3, -- [2]
				},
				["show_timer"] = true,
				["enable_custom_text"] = false,
				["text_size"] = 12,
			},
			["bars_grow_direction"] = 1,
			["menu_alpha"] = {
				["enabled"] = false,
				["onleave"] = 1,
				["ignorebars"] = false,
				["iconstoo"] = true,
				["onenter"] = 1,
			},
			["bg_b"] = 0.0941176470588235,
			["grab_on_top"] = false,
			["menu_anchor_down"] = {
				16, -- [1]
				-3, -- [2]
			},
			["statusbar_info"] = {
				["alpha"] = 0.131542265415192,
				["overlay"] = {
					0.447058823529412, -- [1]
					0.447058823529412, -- [2]
					0.447058823529412, -- [3]
				},
			},
			["hide_in_combat_alpha"] = 0,
			["plugins_grow_direction"] = 1,
			["menu_icons"] = {
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				false, -- [6]
				["space"] = -1,
				["shadow"] = false,
			},
			["desaturated_menu"] = true,
			["show_sidebars"] = false,
			["bg_alpha"] = 0.0242124795913696,
			["instance_button_anchor"] = {
				-27, -- [1]
				1, -- [2]
			},
			["backdrop_texture"] = "Details Ground",
			["version"] = 3,
			["hide_icon"] = true,
			["skin"] = "Minimalistic",
			["toolbar_side"] = 1,
			["bg_g"] = 0.0941176470588235,
			["micro_displays_side"] = 2,
			["wallpaper"] = {
				["overlay"] = {
					0.999997794628143, -- [1]
					0.999997794628143, -- [2]
					0.999997794628143, -- [3]
					0.498038113117218, -- [4]
				},
				["width"] = 266.000061035156,
				["texcoord"] = {
					0.00100000001490116, -- [1]
					1, -- [2]
					0.00100000001490116, -- [3]
					0.703000030517578, -- [4]
				},
				["enabled"] = false,
				["anchor"] = "all",
				["height"] = 225.999984741211,
				["alpha"] = 0.498039245605469,
				["texture"] = "Interface\\TALENTFRAME\\bg-priest-shadow",
			},
			["stretch_button_side"] = 1,
			["micro_displays_locked"] = true,
			["row_info"] = {
				["textL_outline"] = true,
				["textR_outline"] = true,
				["textL_outline_small"] = false,
				["textR_outline_small"] = false,
				["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal_alpha",
				["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
				["textR_show_data"] = {
					true, -- [1]
					true, -- [2]
					false, -- [3]
				},
				["textL_enable_custom_text"] = false,
				["fixed_text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["space"] = {
					["right"] = 0,
					["left"] = 0,
					["between"] = 0,
				},
				["texture_background_class_color"] = false,
				["start_after_icon"] = false,
				["font_face_file"] = "Interface\\Addons\\Details\\fonts\\Accidental Presidency.ttf",
				["textL_custom_text"] = "{data1}. {data3}{data2}",
				["font_size"] = 16,
				["height"] = 21,
				["texture_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
				["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small_alpha",
				["textR_bracket"] = "(",
				["texture_custom"] = "",
				["fixed_texture_color"] = {
					0.498039215686275, -- [1]
					0.498039215686275, -- [2]
					0.498039215686275, -- [3]
					1, -- [4]
				},
				["textL_show_number"] = true,
				["use_spec_icons"] = true,
				["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
				["texture"] = "DGround",
				["models"] = {
					["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
					["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
					["upper_alpha"] = 0.5,
					["lower_enabled"] = false,
					["lower_alpha"] = 0.1,
					["upper_enabled"] = false,
				},
				["texture_custom_file"] = "Interface\\",
				["percent_type"] = 1,
				["textR_enable_custom_text"] = false,
				["fixed_texture_background_color"] = {
					0.188235294117647, -- [1]
					0.188235294117647, -- [2]
					0.188235294117647, -- [3]
					0.3492591381073, -- [4]
				},
				["textR_class_colors"] = false,
				["alpha"] = 0.439999997615814,
				["no_icon"] = false,
				["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar_background",
				["texture_background"] = "DGround",
				["font_face"] = "Accidental Presidency",
				["texture_class_colors"] = false,
				["textL_class_colors"] = false,
				["fast_ps_update"] = false,
				["textR_separator"] = "NONE",
				["backdrop"] = {
					["enabled"] = false,
					["texture"] = "Details BarBorder 2",
					["color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["size"] = 12,
				},
			},
			["bars_inverted"] = false,
		},
		
		callback = function (skin, instance, just_updating)
			--none
		end,
		
		skin_options = {
			{spacement = true, type = "button", name = "Shadowy Title Bar", func = Minimalistic_Shadow, desc = "Adds shadow on title bar components."},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP"], func = reset_tooltip, desc = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"], func = set_tooltip_elvui2, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"]},
		}
		
	})	

		_detalhes:InstallSkin ("Safe Skin Legion Beta", {
		file = [[Interface\AddOns\Details\images\skins\classic_skin_v1.blp]],
		author = "Details!", 
		version = "1.0", 
		site = "unknown", 
		desc = "Simple skin with soft gray color and half transparent frames.", --\n
		
		--micro frames
		micro_frames = {
			color = {1, 1, 1, 1}, 
			font = "Accidental Presidency", 
			size = 10,
			textymod = 1,
		},
		
		can_change_alpha_head = true, 
		icon_anchor_main = {-1, -5}, 
		icon_anchor_plugins = {-7, -13}, 
		icon_plugins_size = {19, 18},
		
		--anchors:
		icon_point_anchor = {-37, 0},
		left_corner_anchor = {-107, 0},
		right_corner_anchor = {96, 0},

		icon_point_anchor_bottom = {-37, 12},
		left_corner_anchor_bottom = {-107, 0},
		right_corner_anchor_bottom = {96, 0},
		
		icon_on_top = true,
		icon_ignore_alpha = true,
		icon_titletext_position = {3, 3},
		
		--overwrites
		instance_cprops = {
			["show_statusbar"] = false,
			["menu_icons_size"] = 0.850000023841858,
			["color"] = {
				0.333333333333333, -- [1]
				0.333333333333333, -- [2]
				0.333333333333333, -- [3]
				0, -- [4]
			},
			["menu_anchor"] = {
				16, -- [1]
				0, -- [2]
				["side"] = 2,
			},
			["bg_r"] = 0.0941176470588235,
			["hide_out_of_combat"] = false,
			["following"] = {
				["bar_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["enabled"] = false,
				["text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
			},
			["color_buttons"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["skin_custom"] = "",
			["menu_anchor_down"] = {
				16, -- [1]
				-3, -- [2]
			},
			["micro_displays_locked"] = true,
			["row_show_animation"] = {
				["anim"] = "Fade",
				["options"] = {
				},
			},
			["tooltip"] = {
				["n_abilities"] = 3,
				["n_enemies"] = 3,
			},
			["total_bar"] = {
				["enabled"] = false,
				["only_in_group"] = true,
				["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
				["color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
			},
			["show_sidebars"] = false,
			["instance_button_anchor"] = {
				-27, -- [1]
				1, -- [2]
			},
			["row_info"] = {
				["textR_outline"] = false,
				["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
				["textL_outline"] = false,
				["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
				["textR_show_data"] = {
					true, -- [1]
					true, -- [2]
					true, -- [3]
				},
				["textL_enable_custom_text"] = false,
				["fixed_text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["space"] = {
					["right"] = 0,
					["left"] = 0,
					["between"] = 0,
				},
				["texture_background_class_color"] = false,
				["start_after_icon"] = true,
				["font_face_file"] = "Interface\\Addons\\Details\\fonts\\Accidental Presidency.ttf",
				["backdrop"] = {
					["enabled"] = false,
					["size"] = 12,
					["color"] = {
						1, -- [1]
						1, -- [2]
						1, -- [3]
						1, -- [4]
					},
					["texture"] = "Details BarBorder 2",
				},
				["font_size"] = 16,
				["height"] = 21,
				["texture_file"] = "Interface\\RaidFrame\\Raid-Bar-Hp-Fill",
				["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
				["textR_bracket"] = "(",
				["textR_enable_custom_text"] = false,
				["fixed_texture_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
				},
				["textL_show_number"] = true,
				["textL_custom_text"] = "{data1}. {data3}{data2}",
				["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
				["fixed_texture_background_color"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					0.150228589773178, -- [4]
				},
				["models"] = {
					["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
					["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
					["upper_alpha"] = 0.5,
					["lower_enabled"] = false,
					["lower_alpha"] = 0.1,
					["upper_enabled"] = false,
				},
				["texture_custom_file"] = "Interface\\",
				["textR_class_colors"] = false,
				["texture_custom"] = "",
				["texture"] = "Blizzard Raid Bar",
				["textL_class_colors"] = false,
				["alpha"] = 1,
				["no_icon"] = false,
				["texture_background"] = "Details D'ictum (reverse)",
				["texture_background_file"] = "Interface\\AddOns\\Details\\images\\bar4_reverse",
				["font_face"] = "Accidental Presidency",
				["texture_class_colors"] = true,
				["percent_type"] = 1,
				["fast_ps_update"] = false,
				["textR_separator"] = ",",
				["use_spec_icons"] = true,
			},
			["plugins_grow_direction"] = 1,
			["menu_alpha"] = {
				["enabled"] = false,
				["onleave"] = 1,
				["ignorebars"] = false,
				["iconstoo"] = true,
				["onenter"] = 1,
			},
			["micro_displays_side"] = 2,
			["grab_on_top"] = false,
			["strata"] = "LOW",
			["bars_grow_direction"] = 1,
			["bg_alpha"] = 0.045324444770813,
			["ignore_mass_showhide"] = false,
			["hide_in_combat_alpha"] = 0,
			["menu_icons"] = {
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				false, -- [6]
				["space"] = -2,
				["shadow"] = false,
			},
			["auto_hide_menu"] = {
				["left"] = false,
				["right"] = false,
			},
			["statusbar_info"] = {
				["alpha"] = 0,
				["overlay"] = {
					0.333333333333333, -- [1]
					0.333333333333333, -- [2]
					0.333333333333333, -- [3]
				},
			},
			["window_scale"] = 1,
			["libwindow"] = {
				["y"] = 90.9987335205078,
				["x"] = -80.0020751953125,
				["point"] = "BOTTOMRIGHT",
			},
			["backdrop_texture"] = "Details Ground",
			["hide_icon"] = true,
			["bg_b"] = 0.0941176470588235,
			["toolbar_side"] = 1,
			["bg_g"] = 0.0941176470588235,
			["desaturated_menu"] = false,
			["wallpaper"] = {
				["enabled"] = false,
				["texcoord"] = {
					0, -- [1]
					1, -- [2]
					0, -- [3]
					0.7, -- [4]
				},
				["overlay"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["anchor"] = "all",
				["height"] = 114.042518615723,
				["alpha"] = 0.5,
				["width"] = 283.000183105469,
			},
			["stretch_button_side"] = 1,
			["attribute_text"] = {
				["enabled"] = true,
				["shadow"] = false,
				["side"] = 1,
				["text_size"] = 12,
				["custom_text"] = "{name}",
				["text_face"] = "Accidental Presidency",
				["anchor"] = {
					-18, -- [1]
					3, -- [2]
				},
				["text_color"] = {
					1, -- [1]
					1, -- [2]
					1, -- [3]
					1, -- [4]
				},
				["enable_custom_text"] = false,
				["show_timer"] = true,
			},
			["bars_sort_direction"] = 1,
		},
		
		callback = function (skin, instance, just_updating)
			--none
		end,
		
		skin_options = {
			{spacement = true, type = "button", name = "Shadowy Title Bar", func = Minimalistic_Shadow, desc = "Adds shadow on title bar components."},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP"], func = reset_tooltip, desc = Loc ["STRING_OPTIONS_SKIN_RESET_TOOLTIP_DESC"]},
			{type = "button", name = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"], func = set_tooltip_elvui2, desc = Loc ["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"]},
		}
		
	})
