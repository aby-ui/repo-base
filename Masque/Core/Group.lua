--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Core\Group.lua
	* Author.: StormFX, JJSheets

	Group API

]]

local MASQUE, Core = ...

----------------------------------------
-- Lua
---

local error, pairs, type = error, pairs, type

----------------------------------------
-- Internal
---

-- @ Skins\Skins
local Skins = Core.Skins

-- @ Skins\Regions
local RegTypes = Core.RegTypes

-- @ Core\Utility
local GetColor = Core.GetColor

-- @ Core\Core
local GetType, GetRegion = Core.GetType, Core.GetRegion

-- @ Core\Button
local SkinButton = Core.SkinButton

-- @ Core\Callback
local Callback = Core.Callback

----------------------------------------
-- Locals
---

local Group, GMT = {}, {}

----------------------------------------
-- Private
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

	if not Type or not RegTypes[Type] then
		Type = GetType(Button, oType)
	end

	Button.__MSQ_bType = Type

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
	Button.__MSQ_Addon = self.Addon

	local db = self.db

	if not db.Disabled and not self.Queued then
		SkinButton(Button, Regions, db.SkinID, db.Backdrop, db.Shadow, db.Gloss, db.Colors)
	end
end

-- Removes a button from the group and applies the default skin.
function GMT:RemoveButton(Button)
	if Button then
		local Regions = self.Buttons[Button]

		if Regions then
			SkinButton(Button, Regions, false)
		end

		Group[Button] = nil
		self.Buttons[Button] = nil
	end
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

-- Reskins the group with its current settings.
function GMT:ReSkin(Silent)
	local db = self.db

	if not db.Disabled then
		for Button, Regions in pairs(self.Buttons) do
			SkinButton(Button, Regions, db.SkinID, db.Backdrop, db.Shadow, db.Gloss, db.Colors)
		end

		if not Silent then
			FireCB(self)
		end
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

-- Creates and returns an AceConfig-3.0 options table for the group.
function GMT:GetOptions(Order)
	return Core.GetOptions(self, Order)
end

-- Enables the group.
-- * This methods is intended for internal use only.
function GMT:Enable()
	self.db.Disabled = false
	self:ReSkin()

	local Subs = self.SubList

	if Subs then
		for _, Sub in pairs(Subs) do
			Sub:Enable()
		end
	end
end

-- Disables the group.
-- * This methods is intended for internal use only.
function GMT:Disable(Silent)
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
			Sub:Disable(Silent)
		end
	end
end

-- Sets the specified layer color.
-- * This methods is intended for internal use only.
function GMT:SetColor(Layer, r, g, b, a)
	if not Layer then return end

	if r then
		self.db.Colors[Layer] = {r, g, b, a}
	else
		self.db.Colors[Layer] = nil
	end

	self:ReSkin()

	local Subs = self.SubList

	if Subs then
		for _, Sub in pairs(Subs) do
			Sub:SetColor(Layer, r, g, b, a)
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
	elseif db[Option] ~= nil then
		Value = (Value and true) or false
		db[Option] = Value
	else
		return
	end

	self:ReSkin()

	local Subs = self.SubList

	if Subs then
		for _, Sub in pairs(Subs) do
			Sub:__Set(Option, Value)
		end
	end
end

-- Resets the group's skin settings.
-- * This methods is intended for internal use only.
function GMT:__Reset()
	self.db.Backdrop = false
	self.db.Shadow = false
	self.db.Gloss = false

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

-- Updates the group on creation or profile activity.
-- * This methods is intended for internal use only.
function GMT:__Update(IsNew)
	local db = Core.db.profile.Groups[self.ID]

	if db == self.db then return end

	-- Update the DB the first time a StaticID is used.
	if self.StaticID and not db.Upgraded then
		local o_id = Core.GetID(self.Addon, self.Group)
		local o_db = Core.db.profile.Groups[o_id]

		if not o_db.Inherit then
			Core.db.profile.Groups[self.ID] = o_db
			db = Core.db.profile.Groups[self.ID]
		end

		Core.db.profile.Groups[o_id] = nil
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

			for Layer in pairs(db.Colors) do
				db.Colors[Layer] = nil
			end

			for Layer in pairs(p_db.Colors) do
				local c = p_db.Colors[Layer]

				if type(c) == "table" then
					db.Colors[Layer] = {c[1], c[2], c[3], c[4]}
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