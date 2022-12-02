--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Options.lua
	* Author.: StormFX

	'Skin Settings' Group/Panel

]]

local MASQUE, Core = ...

----------------------------------------
-- Lua API
---

local pairs = pairs

----------------------------------------
-- Libraries
---

local LIB_ACR = LibStub("AceConfigRegistry-3.0")

----------------------------------------
-- Internal
---

-- @ Locales\enUS
local L = Core.Locale

-- @ Masque
local CRLF = Core.CRLF

-- @ Skins\Skins
local Skins, SkinList, SkinOrder = Core.Skins, Core.SkinList, Core.SkinOrder

-- @ Skins\Blizzard(_Classic)
local DEFAULT_SKIN_ID = Core.DEFAULT_SKIN_ID

-- @ Options\Core
local Setup = Core.Setup

----------------------------------------
-- Utility
---

-- Gets an option value.
local function GetOption(Info)
	local Option = Info[#Info]

	if Option == "SkinID" then
		local SkinID = Info.arg.db.SkinID

		if not SkinList[SkinID] then
			SkinID = DEFAULT_SKIN_ID
		end

		return SkinID
	else
		return Info.arg.db[Option]
	end
end

-- Sets an option value.
local function SetOption(Info, Value)
	Info.arg:__Set(Info[#Info], Value)
end

-- Gets a layer color.
local function GetColor(Info)
	local Layer = Info[#Info]

	if Layer == "Color" then
		Layer = Info[#Info - 1]
	end

	return Info.arg:GetColor(Layer)
end

-- Sets a layer color.
local function SetColor(Info, r, g, b, a)
	local Layer = Info[#Info]

	if Layer == "Color" then
		Layer = Info[#Info - 1]
	end

	Info.arg:__SetColor(Layer, r, g, b, a)
end

-- Resets the skin.
local function Reset(Info)
	Info.arg:__Reset()
end

-- Gets the disabled state of a group or option.
local function GetDisabled(Info)
	return Info.arg.db.Disabled
end

-- Sets the disabled state of a group.
local function SetDisabled(Info, Value)
	if Value then
		Info.arg:__Disable()
	else
		Info.arg:__Enable()
	end
end

-- Gets the disabled state of a color option.
-- @ Backdrop, Shadow, Gloss
local function GetDisabledColor(Info)
	local Layer = Info[#Info-1]
	local db = Info.arg.db

	return (not db[Layer]) or db.Disabled
end

-- Gets the disabled state of a group's parent.
local function GetDisabledParent(Info)
	local Parent = Info.arg.Parent
	return Parent and Parent.db.Disabled
end

-- Gets the disabled state of the Scale option.
local function GetDisabledScale(Info)
	return not Info.arg.db.UseScale
end

-- Gets the hidden state of a group or option.
local function GetHidden(Info)
	local Layer = Info[#Info]

	if Layer == "Color" then
		Layer = Info[#Info - 1]
	end

	local Skin = Skins[Info.arg.db.SkinID] or Core.DEFAULT_SKIN
	return Skin[Layer].Hide
end

-- Updates the sorting order.
local function GetSorting(Info)
	local Order

	if Core.db.profile.AltSort then
		Order = SkinOrder
	end

	return Order
end

----------------------------------------
-- Options Builder
---

-- Creates a skin options group for an add-on or add-on group.
local function GetOptions(obj, Order)
	local Addon, Group = obj.Addon, obj.Group
	local Name, Title, Desc

	if Group then
		local Text = Addon..": "..Group
		Name = Group
		Title = Text
		Desc = L["This section will allow you to adjust the skin settings of all buttons registered to %s."]
		Desc = Desc:format(Text)
	elseif Addon then
		Name = Addon
		Title = Addon
		Desc = L["This section will allow you to adjust the skin settings of all buttons registered to %s. This will overwrite any per-group settings."]
		Desc = Desc:format(Addon)
	else
		Name = L["Global"]
		Title = L["Global Settings"]
		Desc = L["This section will allow you to adjust the skin settings of all registered buttons. This will overwrite any per-add-on settings."]
	end

	return {
		type = "group",
		name = Name,
		desc = "|cffffffff"..L["Select to view."].."|r",
		order = Order,
		args = {
			Head = {
				type = "header",
				name = Title,
				order = 0,
				disabled = true,
				dialogControl = "SFX-Header",
			},
			Desc = {
				type = "description",
				name = Desc..CRLF,
				fontSize = "medium",
				order = 1,
			},
			Disable = {
				type = "toggle",
				name = L["Disable"],
				desc = L["Disable the skinning of this group."],
				get = GetDisabled,
				set = SetDisabled,
				arg = obj,
				disabled = GetDisabledParent,
				order = 2,
			},
			SkinID = {
				type = "select",
				name = L["Skin"],
				desc = L["Set the skin for this group."],
				get = GetOption,
				set = SetOption,
				arg = obj,
				width = "full",
				style = "dropdown",
				values = SkinList,
				sorting = GetSorting,
				disabled = GetDisabled,
				order = 3,
			},
			Reset = {
				type = "execute",
				name = L["Reset Skin"],
				desc = L["Reset all skin options to the defaults."],
				func = Reset,
				arg = obj,
				width = "full",
				disabled = GetDisabled,
				order = 4,
			},
			Spacer = {
				type = "description",
				name = " ",
				order = 5,
			},
			Backdrop = {
				type = "group",
				name = L["Backdrop"],
				arg = obj,
				inline = true,
				hidden = GetHidden,
				order = 6,
				args = {
					Backdrop = {
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable the Backdrop texture."],
						get = GetOption,
						set = SetOption,
						arg = obj,
						disabled = GetDisabled,
						order = 1,
					},
					Color = {
						type = "color",
						name = L["Color"],
						desc = L["Set the color of the Backdrop texture."],
						get = GetColor,
						set = SetColor,
						arg = obj,
						hasAlpha = true,
						disabled = GetDisabledColor,
						order = 2,
					},
				},
			},
			Shadow = {
				type = "group",
				name = L["Shadow"],
				arg = obj,
				inline = true,
				hidden = GetHidden,
				order = 7,
				args = {
					Shadow = {
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable the Shadow texture."],
						get = GetOption,
						set = SetOption,
						arg = obj,
						disabled = GetDisabled,
						order = 1,
					},
					Color = {
						type = "color",
						name = L["Color"],
						desc = L["Set the color of the Shadow texture."],
						get = GetColor,
						set = SetColor,
						arg = obj,
						hasAlpha = true,
						disabled = GetDisabledColor,
						order = 2,
					},
				},
			},
			Gloss = {
				type = "group",
				name = L["Gloss"],
				arg = obj,
				inline = true,
				hidden = GetHidden,
				order = 8,
				args = {
					Gloss = {
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable the Gloss texture."],
						get = GetOption,
						set = SetOption,
						arg = obj,
						disabled = GetDisabled,
						order = 1,
					},
					Color = {
						type = "color",
						name = L["Color"],
						desc = L["Set the color of the Gloss texture."],
						get = GetColor,
						set = SetColor,
						arg = obj,
						hasAlpha = true,
						disabled = GetDisabledColor,
						order = 2,
					},
				},
			},
			Cooldown = {
				type = "group",
				name = L["Cooldown"],
				arg = obj,
				inline = true,
				disabled = GetDisabled,
				order = 9,
				args = {
					Color = {
						type = "color",
						name = L["Color"],
						desc = L["Set the color of the Cooldown animation."],
						get = GetColor,
						set = SetColor,
						arg = obj,
						hasAlpha = true,
						order = 1,
					},
					Pulse = {
						type = "toggle",
						name = L["Pulse"],
						desc = L["Show the pulse effect when a cooldown finishes."],
						get = GetOption,
						set = SetOption,
						arg = obj,
						disabled = GetDisabled,
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
				disabled = GetDisabled,
				order = 10,
				args = {
					Normal = {
						type = "color",
						name = L["Normal"],
						desc = L["Set the color of the Normal texture."],
						arg = obj,
						hasAlpha = true,
						hidden = GetHidden,
						order = 1,
					},
					Highlight = {
						type = "color",
						name = L["Highlight"],
						desc = L["Set the color of the Highlight texture."],
						arg = obj,
						hasAlpha = true,
						order = 2,
					},
					Checked = {
						type = "color",
						name = L["Checked"],
						desc = L["Set the color of the Checked texture."],
						arg = obj,
						hasAlpha = true,
						order = 3,
					},
					Flash = {
						type = "color",
						name = L["Flash"],
						desc = L["Set the color of the Flash texture."],
						arg = obj,
						hasAlpha = true,
						order = 4,
					},
					Pushed = {
						type = "color",
						name = L["Pushed"],
						desc = L["Set the color of the Pushed texture."],
						arg = obj,
						hasAlpha = true,
						order = 5,
					},
				},
			},
			Scale = {
				type = "group",
				name = L["Scale"],
				--arg = obj,
				inline = true,
				order = 11,
				args = {
					UseScale = {
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable skin scaling."],
						get = GetOption,
						set = SetOption,
						arg = obj,
						disabled = GetDisabled,
						order = 1,
					},
					Scale = {
						type = "range",
						name = L["Scale"],
						desc = L["Adjust the scale of this group's skin."],
						get = GetOption,
						set = SetOption,
						arg = obj,
						min = 0.75,
						max = 1.25,
						step = 0.01,
						disabled = GetDisabledScale,
						order = 2,
					},
				},
			},
		},
	}
end

----------------------------------------
-- Setup
---

-- Creates the 'Skin Settings' options group/panel.
function Setup.Skins(self)
	local Options = {
		type = "group",
		name = L["Skin Settings"],
		order = 1,
		args = {
			Head = {
				type = "header",
				name = MASQUE.." - "..L["Skin Settings"],
				order = 0,
				hidden = self.GetStandAlone,
				disabled = true,
				dialogControl = "SFX-Header",
			},
			Desc = {
				type = "description",
				name = L["This section will allow you to skin the buttons of the add-ons and add-on groups registered with Masque."]..CRLF,
				fontSize = "medium",
				order = 1,
			},
		},
	}

	local args = Options.args

	local Global = self.GetGroup()
	args.Global = GetOptions(Global, 2)

	local Addons = Global.SubList

	for aID, aObj in pairs(Addons) do
		args[aID] = GetOptions(aObj)

		local aargs = args[aID].args
		local Groups = aObj.SubList

		for gID, gObj in pairs(Groups) do
			aargs[gID] = GetOptions(gObj)
		end
	end

	self.Options.args.Skins = Options

	local Path = "Skins"
	self:AddOptionsPanel(Path, LibStub("AceConfigDialog-3.0"):AddToBlizOptions(MASQUE, L["Skin Settings"], MASQUE, Path))

	-- GC
	Setup.Skins = nil
end

----------------------------------------
-- Core
---

Core.GetOptions = GetOptions

-- Updates the skin options for the group.
function Core:UpdateSkinOptions(obj, Delete)
	if Setup.Skins then return end

	local ID, Addon, Group = obj.ID, obj.Addon, obj.Group
	local args = self.Options.args.Skins.args

	if Group then
		args = args[Addon].args
	end

	if Delete then
		args[ID] = nil
	elseif not args[ID] then
		args[ID] = GetOptions(obj)
	elseif Group and (args[ID].name ~= Group) then
		args[ID].name = Group
	else
		return
	end

	LIB_ACR:NotifyChange(MASQUE)
end
