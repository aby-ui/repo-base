--[[
	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file.

	* File...: Core\Options.lua
	* Author.: StormFX

]]

local MASQUE, Core = ...
local pairs = pairs

local L = Core.Locale
local Skins, SkinList = Core.Skins, Core.SkinList

----------------------------------------
-- Options Loader
----------------------------------------

-- Loads the options when called.
function Core:LoadOptions()
	local args = self.Options.args.General.args
	args.Info = {
		type = "description",
		name = L["Masque is a dynamic button skinning add-on."].."\n",
		order = 1,
	}
	if Core.LDB then
		args.Icon = {
			type = "toggle",
			name = L["Minimap Icon"],
			desc = L["Enable the Minimap icon."],
			get = function()
				return not Core.db.profile.LDB.hide
			end,
			set = function(i, v)
				Core.db.profile.LDB.hide = not v
				if not v then
					Core.LDBI:Hide(MASQUE)
				else
					Core.LDBI:Show(MASQUE)
				end
			end,
			disabled = function()
				return not Core.LDBI
			end,
			order = 3,
		}
	end
	args.Debug = {
		type = "toggle",
		name = L["Debug Mode"],
		desc = L["Causes Masque to throw Lua errors whenever it encounters a problem with an add-on or skin."],
		get = function()
			return Core.db.profile.Debug
		end,
		set = function()
			Core:Debug()
		end,
		order = 4,
	}
	self.Options.args.Addons = {
		type = "group",
		name = L["Addons"],
		order = 1,
		args = {
			Info = {
				type = "description",
				name = L["This section will allow you to skin the buttons of the add-ons and add-on groups registered with Masque."].."\n",
				order = 0,
			},
		},
	}
	self.Options.args.Addons.args.Global = self:GetOptions()
	self.Options.args.Addons.args.Global.order = 1
	self.OptionsLoaded = true
	self:UpdateOptions()
	for _, Addon in pairs(self:ListAddons()) do
		self:UpdateOptions(Addon)
	end
	self.OptionsPanel.Addons = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(MASQUE, L["Addons"], MASQUE, "Addons")
	self.Options.args.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.Options.args.Profiles.order = -1
	self.OptionsPanel.Profiles = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(MASQUE, L["Profiles"], MASQUE, "Profiles")
	local LDS = LibStub("LibDualSpec-1.0", true)
	if LDS then
		LDS:EnhanceDatabase(self.db, MASQUE)
		LDS:EnhanceOptions(self.Options.args.Profiles, self.db)
	end
end

----------------------------------------
-- Options Window
----------------------------------------

-- Opens the options window.
function Core:ShowOptions()
	if not self.OptionsLoaded then
		self:LoadOptions()
	end
	-- Double call to ensure the proper category is opened.
	InterfaceOptionsFrame_OpenToCategory(Core.OptionsPanel)
	InterfaceOptionsFrame_OpenToCategory(Core.OptionsPanel.Addons)
end

----------------------------------------
-- Options Updater
----------------------------------------

-- Updates the specified add-on options.
function Core:UpdateOptions(Addon, Group, Delete)
	if not self.OptionsLoaded then
		return
	end
	local args = self.Options.args.Addons.args
	if Delete then
		if Addon then
			local a = Addon:gsub("%s", "_")
			if Group then
				local g = Group:gsub("%s", "_")
				local aargs = args[a].args
				aargs[g] = nil
			else
				args[a] = nil
			end
		end
	else
		if not Addon then
			for _, Addon in pairs(self:ListAddons()) do
				local a = Addon:gsub("%s", "_")
				args[a] = args[a] or self:GetOptions(Addon)
			end
		elseif not Group then
			local a = Addon:gsub("%s", "_")
			for _, Group in pairs(self:ListGroups(Addon)) do
				local g = Group:gsub("%s", "_")
				local aargs = args[a].args
				aargs[g] = aargs[g] or self:GetOptions(Addon, Group)
			end
		end
	end
	Core.ACR:NotifyChange(MASQUE)
end

----------------------------------------
-- Options API
----------------------------------------

do
	-- Gets an option's value.
	local function GetOption(info)
		local Option = info[#info]
		if Option == "SkinID" then
			return SkinList[info.arg.db.SkinID] or SkinList["Blizzard"]
		else
			return info.arg.db[Option]
		end
	end

	-- Sets an option's value.
	local function SetOption(info, value)
		info.arg:SetOption(info[#info], value)
	end

	-- Gets a layer color.
	local function GetColor(info)
		local Layer = info[#info]
		if Layer == "Color" then
			Layer = info[#info-1]
		end
		return info.arg:GetColor(Layer)
	end

	-- Sets a layer color.
	local function SetColor(info, r, g, b, a)
		local Layer = info[#info]
		if Layer == "Color" then
			Layer = info[#info-1]
		end
		info.arg:SetColor(Layer, r, g, b, a)
	end

	-- Resets the skin.
	local function Reset(info)
		info.arg:Reset()
	end

	-- Gets the disabled state of a group.
	local function GetGroupState(info)
		return info.arg.db.Disabled
	end

	-- Sets the disabled state of a group.
	local function SetGroupState(info, value)
		if value then
			info.arg:Disable()
		else
			info.arg:Enable()
		end
	end

	-- Gets the disabled state of a group's parent.
	local function GetParentState(info)
		local Parent = info.arg.Parent
		return Parent and Parent.db.Disabled
	end

	-- Gets the state of a layer.
	local function GetState(info)
		local db, Layer = info.arg.db, info[#info]
		local Skin = Skins[db.SkinID] or Skins["Blizzard"]
		if Layer == "Color" then
			Layer = info[#info-1]
		end
		if Layer == "Border" then
			return (not info.arg.IsActionBar) or Skin[Layer].Hide or db.Disabled
		else
			return Skin[Layer].Hide or db.Disabled
		end
	end

	-- Gets the state of the backdrop color.
	local function GetBackdropState(info)
		local db = info.arg.db
		return (not db.Backdrop) or db.Disabled
	end

	-- Returns an options group for an add-on or add-on group.
	function Core:GetOptions(Addon, SubGroup)
		local Group = Core:Group(Addon, SubGroup)
		local Name, Info
		if SubGroup then
			Name = SubGroup
			Info = (L["Adjust the skin of all buttons registered to %s: %s."]):format(Addon, SubGroup)
		elseif Addon then
			Name = Addon
			Info = (L["Adjust the skin of all buttons registered to %s. This will overwrite any per-group settings."]):format(Addon)
		else
			Name = L["Global"]
			Info = L["Adjust the skin of all registered buttons. This will overwrite any per-add-on settings."]
		end
		return {
			type = "group",
			name = Name,
			args = {
				Info = {
					type = "description",
					name = Info.."\n",
					order = 0,
				},
				Disable = {
					type = "toggle",
					name = L["Disable"],
					desc = L["Disable the skinning of this group."],
					get = GetGroupState,
					set = SetGroupState,
					arg = Group,
					disabled = GetParentState,
					order = 1,
				},
				SkinID = {
					type = "select",
					name = L["Skin"],
					desc = L["Set the skin for this group."],
					get = GetOption,
					set = SetOption,
					arg = Group,
					style = "dropdown",
					width = "full",
					values = SkinList,
					disabled = GetGroupState,
					order = 2,
				},
				Spacer = {
					type = "description",
					name = " ",
					order = 3,
				},
				Gloss = {
					type = "group",
					name = L["Gloss Settings"],
					inline = true,
					disabled = GetState,
					order = 4,
					args = {
						Color = {
							type = "color",
							name = L["Color"],
							desc = L["Set the color of the Gloss texture."],
							get = GetColor,
							set = SetColor,
							arg = Group,
							order = 1,
						},
						Gloss = {
							type = "range",
							name = L["Opacity"],
							desc = L["Set the intensity of the Gloss color."],
							get = GetOption,
							set = SetOption,
							arg = Group,
							min = 0,
							max = 1,
							step = 0.05,
							isPercent = true,
							order = 2,
						},
					},
				},
				Backdrop = {
					type = "group",
					name = L["Backdrop Settings"],
					inline = true,
					order = 5,
					args = {
						Backdrop = {
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable the Backdrop texture."],
							get = GetOption,
							set = SetOption,
							arg = Group,
							disabled = GetState,
							order = 1,
						},
						Color = {
							type = "color",
							name = L["Color"],
							desc = L["Set the color of the Backdrop texture."],
							get = GetColor,
							set = SetColor,
							arg = Group,
							disabled = GetBackdropState,
							hasAlpha = true,
							order = 2,
						},
					},
				},
				Colors = {
					type = "group",
					name = L["Colors"],
					get = GetColor,
					set = SetColor,
					inline = true,
					disabled = GetState,
					order = 6,
					args = {
						Normal = {
							type = "color",
							name = L["Normal"],
							desc = L["Set the color of the Normal texture."],
							arg = Group,
							hasAlpha = true,
							order = 1,
						},
						Highlight = {
							type = "color",
							name = L["Highlight"],
							desc = L["Set the color of the Highlight texture."],
							arg = Group,
							hasAlpha = true,
							order = 2,
						},
						Checked = {
							type = "color",
							name = L["Checked"],
							desc = L["Set the color of the Checked texture."],
							arg = Group,
							hasAlpha = true,
							order = 3,
						},
						Border = {
							type = "color",
							name = L["Equipped"],
							desc = L["Set the color of the Equipped item texture."],
							arg = Group,
							hasAlpha = true,
							order = 4,
						},
						Flash = {
							type = "color",
							name = L["Flash"],
							desc = L["Set the color of the Flash texture."],
							arg = Group,
							hasAlpha = true,
							order = 5,
						},
						Pushed = {
							type = "color",
							name = L["Pushed"],
							desc = L["Set the color of the Pushed texture."],
							arg = Group,
							hasAlpha = true,
							order = 6,
						},
						Disabled = {
							type = "color",
							name = L["Disabled"],
							desc = L["Set the color of the Disabled texture."],
							arg = Group,
							hasAlpha = true,
							order = 7,
						},
						Cooldown = {
							type = "color",
							name = L["Cooldown"],
							desc = L["Set the color of the Cooldown animation."],
							arg = Group,
							hasAlpha = true,
							order = 8,
						},
					},
				},
				Reset = {
					type = "execute",
					name = L["Reset Skin"],
					desc = L["Reset all skin options to the defaults."],
					func = Reset,
					arg = Group,
					width = "full",
					disabled = GetGroupState,
					order = -1,
				},
			},
		}
	end
end
