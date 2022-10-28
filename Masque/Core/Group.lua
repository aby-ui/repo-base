--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Group.lua
	* Author.: StormFX, JJSheets

	Group API

]]

local MASQUE, Core = ...

----------------------------------------
-- Lua API
---

local error, pairs, type = error, pairs, type

----------------------------------------
-- Internal
---

-- @ Skins\Skins
local Skins = Core.Skins

-- @ Skins\Regions
local ActionTypes, BaseTypes, RegTypes = Core.ActionTypes, Core.BaseTypes, Core.RegTypes

-- @ Core\Utility
local GetColor, GetScale, NoOp = Core.GetColor, Core.GetScale, Core.NoOp

-- @ Core\Core
local GetRegion, GetSubType, GetType = Core.GetRegion, Core.GetSubType, Core.GetType

-- @ Core\Button
local SkinButton = Core.SkinButton

-- @ Core\Callback
local Callback = Core.Callback

-- @ Core\Regions\*
local SetPulse, SetTextureColor = Core.SetPulse, Core.SetTextureColor

----------------------------------------
-- Locals
---

-- Group Tables
local Group, GMT = {}, {}

-- layers with Color Options
local C_Layers = {
	Backdrop = true,
	Checked = true,
	Cooldown = true,
	Flash = true,
	Gloss = true,
	Highlight = true,
	Normal = true,
	Pushed = true,
	Shadow = true,
}

----------------------------------------
-- Functions
---

-- Fires the callback for the add-on or group.
local function FireCB(self)
	local db = self.db

	if self.Callback then
		Callback(self.ID, self.Group, db.SkinID, db.Backdrop, db.Shadow, db.Gloss, db.Colors, db.Disabled)
	elseif self.Addon then
		Callback(self.Addon, self.Group, db.SkinID, db.Backdrop, db.Shadow, db.Gloss, db.Colors, db.Disabled)
	end
end

----------------------------------------
-- Group Metatable
---

-- Adds or reassigns a button to the group.
function GMT:AddButton(Button, Regions, Type, Strict)
	local oType = GetType(Button)

	if not oType then
		if Core.Debug then
			error("Bad argument to group method 'AddButton'. 'Button' must be a button object.", 2)
		end
		return
	elseif oType == "Frame" then
		Strict = true
	end

	Type = Type or Button.__MSQ_bType

	local Checked

	if not Type or not RegTypes[Type] then
		Type = GetType(Button, oType)
		Checked = true
	end

	if BaseTypes[Type] and not Checked then
		Type = GetSubType(Button, Type)
	end

	Button.__MSQ_bType = Type

	if ActionTypes[Type] then
		self.ActionButtons = true
	end

	Regions = Regions or Button.__Regions

	local Parent = Group[Button]

	if Parent then
		if Parent == self then
			return
		else
			Regions = Regions or Parent.Buttons[Button]
			Parent.Buttons[Button] = nil
		end
	end

	Group[Button] = self

	if type(Regions) ~= "table" then
		Regions = {}
	end

	if not Strict then
		local Layers = RegTypes[Type]

		for Layer, Info in pairs(Layers) do
			local Region = Regions[Layer]

			if Region == nil and not Info.Ignore then
				if Layer == "AutoCastShine" then
					Region = Regions.Shine or Regions.AutoCast or GetRegion(Button, Info)
				elseif Layer == "Backdrop" then
					Region = Regions.FloatingBG or GetRegion(Button, Info)
				else
					Region = GetRegion(Button, Info)
				end

				Regions[Layer] = Region
			end
		end
	end

	self.Buttons[Button] = Regions
	Button.__Regions = Regions
	Button.__MSQ_Addon = self.Addon

	local db = self.db

	if not db.Disabled and not self.Queued then
		SkinButton(Button, Regions, db.SkinID, db.Backdrop, db.Shadow, db.Gloss, db.Colors, db.Pulse)
	end
end

-- Deletes the group and applies the default skin to its buttons.
function GMT:Delete()
	local Subs = self.SubList

	if Subs then
		for _, Sub in pairs(Subs) do
			Sub:Delete()
		end
	end

	for Button in pairs(self.Buttons) do
		self:RemoveButton(Button)
	end

	local Parent = self.Parent

	if Parent then
		Parent.SubList[self.ID] = nil
	end

	Core:UpdateSkinOptions(self, true)
	Core.Groups[self.ID] = nil
end

-- Returns a layer's current color.
function GMT:GetColor(Layer)
	if Layer then
		local Skin = Skins[self.db.SkinID] or Skins.Classic
		return GetColor(self.db.Colors[Layer] or Skin[Layer].Color)
	end
end

-- Returns a button region.
function GMT:GetLayer(Button, Layer)
	if Button and Layer then
		local Regions = self.Buttons[Button]

		if Regions then
			return Regions[Layer]
		end
	end
end

-- Creates and returns an AceConfig-3.0 options table for the group.
function GMT:GetOptions(Order)
	return Core.GetOptions(self, Order)
end

-- Removes a button from the group and applies the default skin.
function GMT:RemoveButton(Button)
	if Button then
		local Regions = self.Buttons[Button]

		if Regions and not self.db.Disabled then
			SkinButton(Button, Regions, false)
		end

		Group[Button] = nil
		self.Buttons[Button] = nil
	end
end

-- Reskins the group with its current settings.
function GMT:ReSkin(arg)
	local db = self.db

	if not db.Disabled then
		if type(arg) == "table" then
			local Regions = self.Buttons[arg]

			if Regions then
				SkinButton(arg, Regions, db.SkinID, db.Backdrop, db.Shadow, db.Gloss, db.Colors, db.Pulse)
			end
		else
			local SkinID, Backdrop, Shadow = db.SkinID, db.Backdrop, db.Shadow
			local Gloss, Colors, Pulse = db.Gloss, db.Colors, db.Pulse

			for Button, Regions in pairs(self.Buttons) do
				SkinButton(Button, Regions, SkinID, Backdrop, Shadow, Gloss, Colors, Pulse)
			end

			if not arg then
				FireCB(self)
			end
		end
	end
end

-- Registers a group-specific callback.
function GMT:SetCallback(func, arg)
	if self.ID == MASQUE then return end

	if type(func) ~= "function" then
		if Core.Debug then
			error("Bad argument to Group method 'SetCallback'. 'func' must be a function.", 2)
		end
		return
	elseif arg and type(arg) ~= "table" then
		if Core.Debug then
			error("Bad argument to Group method 'SetCallback'. 'arg' must be a table or nil.", 2)
		end
		return
	end

	Callback:Register(self.ID, func, arg or false)
	self.Callback = true
end

-- Renames the group.
function GMT:SetName(Name)
	if not self.StaticID then
		return
	elseif type(Name) ~= "string" or self.ID == MASQUE then
		if Core.Debug then
			error("Bad argument to group method 'SetName'. 'Name' must be a string.", 2)
		end
		return
	end

	self.Group = Name
	Core:UpdateSkinOptions(self)
end

----------------------------------------
-- Internal Methods
---

-- Disables the group.
-- * This methods is intended for internal use only.
function GMT:__Disable(Silent)
	self.db.Disabled = true

	for Button, Regions in pairs(self.Buttons) do
		SkinButton(Button, Regions, false)
	end

	if not Silent then
		FireCB(self)
	end

	local Subs = self.SubList

	if Subs then
		for _, Sub in pairs(Subs) do
			Sub:__Disable(Silent)
		end
	end
end

-- Enables the group.
-- * This methods is intended for internal use only.
function GMT:__Enable()
	self.db.Disabled = false
	self:ReSkin()

	local Subs = self.SubList

	if Subs then
		for _, Sub in pairs(Subs) do
			Sub:__Enable()
		end
	end
end

-- Resets the group's skin settings.
-- * This methods is intended for internal use only.
function GMT:__Reset()
	self.db.Backdrop = false
	self.db.Shadow = false
	self.db.Gloss = false
	self.db.Pulse = true

	for Layer in pairs(self.db.Colors) do
		self.db.Colors[Layer] = nil
	end

	self:ReSkin()

	local Subs = self.SubList

	if Subs then
		for _, Sub in pairs(Subs) do
			Sub:__Reset()
		end
	end
end

-- Validates and sets a skin option.
-- * This methods is intended for internal use only.
function GMT:__Set(Option, Value)
	if not Option then return end

	local db = self.db

	if Option == "SkinID" then
		if Value and Skins[Value] then
			db.SkinID = Value
		end

		self:ReSkin()
	elseif db[Option] ~= nil then
		Value = (Value and true) or false
		db[Option] = Value

		if Option == "Pulse" then
			for Button in pairs(self.Buttons) do
				SetPulse(Button, Value)
			end
		else
			local func = Core["Skin"..Option]

			if func then
				local Skin = Skins[db.SkinID] or Skins.Classic

				if Option == "Backdrop" then
					for Button, Regions in pairs(self.Buttons) do
						func(Value, Regions.Backdrop, Button, Skin.Backdrop, db.Colors.Backdrop, GetScale(Button))
					end
				else
					for Button in pairs(self.Buttons) do
						func(Value, Button, Skin[Option], db.Colors[Option], GetScale(Button))
					end
				end
			end
		end
	else
		return
	end

	-- SubGroups
	local Subs = self.SubList

	if Subs then
		for _, Sub in pairs(Subs) do
			Sub:__Set(Option, Value)
		end
	end
end

-- Sets the specified layer color.
-- * This methods is intended for internal use only.
function GMT:__SetColor(Layer, r, g, b, a)
	if not Layer then return end

	local db = self.db
	local Skin = Skins[db.SkinID] or Skins.Classic
	local sr, sg, sb, sa = GetColor(Skin[Layer].Color)

	-- Prevent saving the skin's default color.
	if r and ((r ~= sr) or (g ~= sg) or (b ~= sb) or (a ~= sa)) then
		db.Colors[Layer] = {r, g, b, a}
	else
		db.Colors[Layer] = nil
	end

	local func = Core["Set"..Layer.."Color"]

	if func then
		for Button, Regions in pairs(self.Buttons) do
			func(Regions[Layer], Button, Skin[Layer], db.Colors[Layer])
		end
	else
		for Button, Regions in pairs(self.Buttons) do
			SetTextureColor(Layer, Regions[Layer], Button, Skin[Layer], db.Colors[Layer])
		end
	end

	local Subs = self.SubList

	if Subs then
		for _, Sub in pairs(Subs) do
			Sub:__SetColor(Layer, r, g, b, a)
		end
	end
end

-- Updates the group on creation or profile activity.
-- * This methods is intended for internal use only.
function GMT:__Update(IsNew)
	local db_Groups = Core.db.profile.Groups
	local db = db_Groups[self.ID]

	if db == self.db then return end

	-- Update the DB the first time a StaticID is used.
	if self.StaticID and not db.Upgraded then
		local o_id = Core.GetID(self.Addon, self.Group)
		local o_db = db_Groups[o_id]

		if not o_db.Inherit then
			db_Groups[self.ID] = o_db
			db = db_Groups[self.ID]
		end

		db_Groups[o_id] = nil
		db.Upgraded = true
	end

	self.db = db

	-- Inheritance
	if self.Parent then
		local p_db = self.Parent.db

		if db.Inherit then
			db.SkinID = p_db.SkinID
			db.Backdrop = p_db.Backdrop
			db.Shadow = p_db.Shadow
			db.Gloss = p_db.Gloss
			db.Pulse = p_db.Pulse

			local Colors = db.Colors
			local p_Colors = p_db.Colors

			for Layer in pairs(C_Layers) do
				local Color = Colors[Layer]
				local p_Color = p_Colors[Layer]

				if type(p_Color) == "table" then
					Color = Color or {}

					Color[1] = p_Color[1]
					Color[2] = p_Color[2]
					Color[3] = p_Color[3]
					Color[4] = p_Color[4]

					Colors[Layer] = Color
				else
					Colors[Layer] = nil
				end
			end

			db.Inherit = false
		end

		if p_db.Disabled then
			db.Disabled = true
		end
	end

	if IsNew then
		-- Queue the group if PLAYER_LOGIN hasn't fired and the skin hasn't loaded.
		if Core.Queue and not self.Queued and not Skins[db.SkinID] then
			Core.Queue(self)
		end

		Core:UpdateSkinOptions(self)
	else
		if db.Disabled then
			for Button, Regions in pairs(self.Buttons) do
				SkinButton(Button, Regions, false)
			end
		else
			self:ReSkin()
		end

		local Subs = self.SubList

		if Subs then
			for _, Sub in pairs(Subs) do
				Sub:__Update()
			end
		end
	end
end

----------------------------------------
-- Deprecated
---

GMT.Disable = NoOp
GMT.Enable = NoOp
GMT.SetColor = NoOp

----------------------------------------
-- Core
---

Core.Group_MT = {__index = GMT}

function GMT:ReSkinWithSub()
    self:ReSkin(true)
    local Subs = self.SubList
    if Subs then
        for _, Sub in pairs(Subs) do
            Sub:ReSkinWithSub()
        end
    end
end

-- 切换但是不修改状态
function GMT:ToggleWithoutSave(enable)
    if enable then
        self:ReSkin(true)
    else
        for Button in pairs(self.Buttons) do
            SkinButton(Button, self.Buttons[Button], "Classic")
        end
    end
    local Subs = self.SubList
    if Subs then
        for _, Sub in pairs(Subs) do
            Sub:ToggleWithoutSave(enable)
        end
    end
end
