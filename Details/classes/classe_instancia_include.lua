
local _detalhes = 		_G._detalhes
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

function _detalhes:ResetInstanceConfig (maintainsnap)
	for key, value in pairs (_detalhes.instance_defaults) do 
		if (type (value) == "table") then
			self [key] = table_deepcopy (value)
		else
			self [key] = value
		end
	end
	if (not maintainsnap) then
		self.snap = {}
		self.horizontalSnap = nil
		self.verticalSnap = nil
		self:LockInstance (false)
	end
end

_detalhes.instance_skin_ignored_values = {
	["menu_icons"] = true,
	["auto_hide"] = true,
	["scale"] = true,
	["following"] = true,
	["auto_current"] = true,
	["bars_grow_direction"] = true,
	["bars_sort_direction"] = true,
	["auto_hide_menu"] = true,
	["menu_alpha"] = true,
	["total_bar"] = true,
	["hide_in_combat"] = true,
	["hide_out_of_combat"] = true,
	["hide_in_combat_type"] = true,
	["hide_in_combat_alpha"] = true,
	["switch_all_roles_in_combat"] = true,
	["switch_all_roles_after_wipe"] = true,
	["switch_damager"] = true,
	["switch_damager_in_combat"] = true,
	["switch_healer"] = true,
	["switch_healer_in_combat"] = true,
	["switch_tank"] = true,
	["switch_tank_in_combat"] = true,
	["strata"] = true,
	["grab_on_top"] = true,
	["libwindow"] = true,
	["ignore_mass_showhide"] = true,
	["window_scale"] = true,
}

function _detalhes:ResetInstanceConfigKeepingValues (maintainsnap)
	for key, value in pairs (_detalhes.instance_defaults) do 
		if (not _detalhes.instance_skin_ignored_values [key]) then
			if (type (value) == "table") then
				self [key] = table_deepcopy (value)
			else
				self [key] = value
			end
		end
	end
	if (not maintainsnap) then
		self.snap = {}
		self.horizontalSnap = nil
		self.verticalSnap = nil
		self:LockInstance (false)
	end
end

function _detalhes:LoadInstanceConfig()
	for key, value in pairs (_detalhes.instance_defaults) do 
		if (self [key] == nil) then
			if (type (value) == "table") then
				self [key] = table_deepcopy (_detalhes.instance_defaults [key])
			else
				self [key] = value
			end
			
		elseif (type (value) == "table") then
			for key2, value2 in pairs (value) do 
				if (self [key] [key2] == nil) then
					if (type (value2) == "table") then
						self [key] [key2] = table_deepcopy (_detalhes.instance_defaults [key] [key2])
					else
						self [key] [key2] = value2
					end
				end
			end
		end
	end
end

_detalhes.instance_defaults = {

	--> click through settings
	clickthrough_toolbaricons = false,
	clickthrough_rows = false,
	clickthrough_window = false,
	clickthrough_incombatonly = true,

	--> window settings
		ignore_mass_showhide = false,
	--skin
		skin = _detalhes.default_skin_to_use,
		skin_custom = "",
	--scale
		window_scale = 1.0,
		libwindow = {},
	--following
		following = {enabled = false, bar_color = {1, 1, 1}, text_color = {1, 1, 1}},
	--baseframe backdrop
		bg_alpha = 0.7,
		bg_r = 0.0941,
		bg_g = 0.0941,
		bg_b = 0.0941,
		backdrop_texture = "Details Ground",
	--auto current
		auto_current = true,
	--show sidebars
		show_sidebars = true,
	--show bottom statusbar
		show_statusbar = true,
		statusbar_info = {alpha = 1, overlay = {1, 1, 1}},
	--hide main window attribute icon
		hide_icon = false,
	--anchor side of main window toolbar (1 = top 2 = bottom)
		toolbar_side = 1,
	--micro displays side
		micro_displays_side = 2,
		micro_displays_locked = true,
	--stretch button anchor side (1 = top 2 = bottom)
		stretch_button_side = 1,
	--where plugins icon will be placed on main window toolbar (1 = left 2 = right)
		plugins_grow_direction = 2,
	--grow direction of main window bars (1 = top to bottom 2 = bottom to top)
		bars_grow_direction = 1,
	--sort direction is the direction of results on bars (1 = top to bottom 2 = bottom to top)
		bars_sort_direction = 1,
	--left to right or right to left bars
		bars_inverted = false,
	--toolbar icons file
		--toolbar_icon_file = [[Interface\AddOns\Details\images\toolbar_icons_grayscale]],
		toolbar_icon_file = [[Interface\AddOns\Details\images\toolbar_icons]],
	--menus:
		--anchor store the anchor point of main menu
		menu_anchor = {5, 1, side = 1}, --mode segment attribute report on top position
		menu_anchor_down = {5, 1}, --mode segment attribute report on bottom position
		--blackwhiite icons
		desaturated_menu = false, --mode segment attribute report
		--icons on menu
		menu_icons = {true, true, true, true, true, false, space = -2, shadow = false}, --mode segment attribute report reset close
		--menu icons size multiplicator factor
		menu_icons_size = 1.0, --mode segment attribute report
		--auto hide menu buttons
		auto_hide_menu = {left = false, right = false},
		--attribute text
		attribute_text = {
			enabled = false, 
			anchor = {5, 1}, 
			text_face = "Friz Quadrata TT", 
			text_size = 12, 
			text_color = {1, 1, 1, 1}, 
			side = 1, 
			shadow = false,
			enable_custom_text = false,
			custom_text = "{name}",
			show_timer = {true, true, true}, --raid encounter, battleground, arena
		},
	--auto hide window borders statusbar main menu
		menu_alpha = {enabled = false, iconstoo = true, onenter = 1, onleave = 1, ignorebars = false},
	--instance button anchor store the anchor point of instance and delete button
		instance_button_anchor = {-27, 1},
	--total bar
		total_bar = {enabled = false, color = {1, 1, 1}, only_in_group = true, icon = [[Interface\ICONS\INV_Sigil_Thorim]]},
	--row animation when show
		row_show_animation = {anim = "Fade", options = {}},
	--row info
		row_info = {
			--if true the texture of the bars will have the color of his actor class
				texture_class_colors = true,
			--if texture class color are false, this color will be used
				fixed_texture_color = {0, 0, 0},
			--row alpha
				alpha = 1,
			--left text class color
				textL_class_colors = false,
			--right text class color
				textR_class_colors = false,
			--left text customization
				textL_enable_custom_text = false,
				textL_custom_text = "{data1}. {data3}{data2}",
			--right text customization
				textR_enable_custom_text = false,
				textR_custom_text = "{data1} ({data2}, {data3}%)",
			--right text show which infos
				textR_show_data = {true, true, true},
				textR_bracket = "(",
				textR_separator = ",",
			--left text bar number
				textL_show_number = true,
			--if text class color are false, this color will be used
				fixed_text_color = {1, 1, 1},
			--left text outline effect
				textL_outline = true,
				textL_outline_small = true,
				textL_outline_small_color = {0, 0, 0, 1},
			--right text outline effect
				textR_outline = false,
				textR_outline_small = true,
				textR_outline_small_color = {0, 0, 0, 1},
			--bar height
				height = 14,
			--font size
				font_size = 10,
			--font face (name)
				font_face = "Arial Narrow",
			--font face (file)
				font_face_file = SharedMedia:Fetch ("font", "Arial Narrow"),
			--bar texture
				texture = "Details D'ictum",
				texture_custom = "",
			--bar texture name
				texture_file = [[Interface\AddOns\Details\images\bar4]],
				texture_custom_file = "Interface\\",
			--bar texture on mouse over
				texture_highlight = [[Interface\FriendsFrame\UI-FriendsList-Highlight]],
			--bar background texture
				texture_background = "Details D'ictum",
			--bar background file
				texture_background_file = [[Interface\AddOns\Details\images\bar4]],
			--bar background class color
				texture_background_class_color = true,
			--fixed texture color for background texture
				fixed_texture_background_color = {0, 0, 0, 0},
			--space between bars
				space = {left = 3, right = -5, between = 1},
			--icon file
				icon_file = [[Interface\AddOns\Details\images\classes_small]],
				no_icon = false,
				start_after_icon = true,
				icon_grayscale = false,
			--icon offset
				icon_offset = {0, 0}, --x y
			--percent type
				percent_type = 1,
			--backdrop
				backdrop = {enabled = false, size = 12, color = {1, 1, 1, 1}, texture = "Details BarBorder 2"},
			--model
				models = {
					upper_enabled = false,
					upper_model = [[Spells\AcidBreath_SuperGreen.M2]],
					upper_alpha = 0.50,
					lower_enabled = false,
					lower_model = [[World\EXPANSION02\DOODADS\Coldarra\COLDARRALOCUS.m2]],
					lower_alpha = 0.10,
				},
			--fast hps/dps updates
				fast_ps_update = false,
			--show spec icons
				use_spec_icons = false,
				spec_file = [[Interface\AddOns\Details\images\spec_icons_normal]],
		},
	--instance window color
		color = {1, 1, 1, 1},
		color_buttons = {1, 1, 1, 1},
	--hide in combat
		hide_in_combat = false,
		hide_out_of_combat = false,
		
		hide_in_combat_type = 1,
		hide_in_combat_alpha = 0,
	--switches
		switch_all_roles_in_combat = false,
		switch_all_roles_after_wipe = false,
		switch_damager = false,
		switch_damager_in_combat = false,
		switch_healer = false,
		switch_healer_in_combat = false,
		switch_tank = false,
		switch_tank_in_combat = false,
	--strata
		strata = "LOW",
		grab_on_top = false,
	--wallpaper
		wallpaper = {
			enabled = false,
			texture = nil,
			anchor = "all",
			alpha = 0.5,
			texcoord = {0, 1, 0, 1},
			width = 0,
			height = 0,
			overlay = {1, 1, 1, 1}
		},
	--tooltip amounts
	tooltip = {
			["n_abilities"] = 3, 
			["n_enemies"] = 3
		}
}
