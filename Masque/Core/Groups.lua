--[[
	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file.

	* File...: Core\Groups.lua
	* Author.: StormFX, JJSheets

]]

local MASQUE, Core = ...

-- Lua Functions
local error, pairs, setmetatable, type, unpack = error, pairs, setmetatable, type, unpack

-- Internal Methods
local Skins, SkinList = Core.Skins, Core.SkinList
local GetColor, SkinButton = Core.GetColor, Core.SkinButton

---------------------------------------------
-- Callbacks
---------------------------------------------

local FireCB

do
	local Callbacks = {}

	-- Notifies an add-on of skin changes.
	function FireCB(Addon, Group, SkinID, Gloss, Backdrop, Colors, Disabled)
		local args = Callbacks[Addon]
		if args then
			for arg, callback in pairs(args) do
				callback(arg and arg, Group, SkinID, Gloss, Backdrop, Colors, Disabled)
			end
		end
	end

	-- API: Registers an add-on to be notified on skin changes.
	function Core.API:Register(Addon, Callback, arg)
		local arg = Callback and arg or false
		Callbacks[Addon] = Callbacks[Addon] or {}
		Callbacks[Addon][arg] = Callback
	end
end

---------------------------------------------
-- Groups
---------------------------------------------

local Groups = {}
local GMT

-- Returns a group's ID.
local function GetID(Addon, Group)
	local id = MASQUE
	if type(Addon) == "string" then
		id = Addon
		if type(Group) == "string" then
			id = id.."_"..Group
		end
	end
	return id
end

-- Creates a new group.
local function NewGroup(Addon, Group, IsActionBar)
	local id = GetID(Addon, Group)
	local o = {
		Addon = Addon,
		Group = Group,
		ID = id,
		Buttons = {},
		SubList = (not Group and {}) or nil,
		IsActionBar = IsActionBar,
	}
	setmetatable(o, GMT)
	Groups[id] = o
	if Addon then
		local Parent = Groups[MASQUE] or NewGroup()
		o.Parent = Parent
		Parent.SubList[Addon] = Addon
		Core:UpdateOptions()
	end
	if Group then
		local Parent = Groups[Addon] or NewGroup(Addon)
		o.Parent = Parent
		Parent.SubList[id] = Group
		Core:UpdateOptions(Addon)
	end
	o:Update(true)
	return o
end

-- Returns a button group.
function Core:Group(Addon, Group, IsActionBar)
	return Groups[GetID(Addon, Group)] or NewGroup(Addon, Group, IsActionBar)
end

-- Returns a list of registered add-ons.
function Core:ListAddons()
	local Group = self:Group()
	return Group.SubList
end

-- Returns a list of button groups registered to an add-on.
function Core:ListGroups(Addon)
	return Groups[Addon].SubList
end

-- API: Validates and returns a button group.
function Core.API:Group(Addon, Group, IsActionBar)
	if type(Addon) ~= "string" or Addon == MASQUE then
		if Core.db.profile.Debug then
			error("Bad argument to method 'Group'. 'Addon' must be a string.", 2)
		end
		return
	end
	return Core:Group(Addon, Group, IsActionBar)
end

---------------------------------------------
-- Group Metatable
---------------------------------------------

do
	local Group = {}
	local Layers = {
		FloatingBG = "Texture",
		Icon = "Texture",
		Cooldown = "Frame",
		Flash = "Texture",
		Pushed = "Special",
		Disabled = "Special",
		Checked = "Special",
		Border = "Texture",
		AutoCastable = "Texture",
		Highlight = "Special",
		Name = "Text",
		Count = "Text",
		HotKey = "Text",
		Duration = "Text",
		Shine = "Frame",
	}

	-- Gets a button region.
	local function GetRegion(Button, Layer, Type)
		local Region
		if Type == "Special" then
			local f = Button["Get"..Layer.."Texture"]
			Region = (f and f(Button)) or false
		else
			local n = Button:GetName()
			Region = (n and _G[n..Layer]) or false
		end
		return Region
	end

	GMT = {
		__index = {

			-- Adds or reassigns a button to the group.
			AddButton = function(self, Button, ButtonData)
				if type(Button) ~= "table" then
					if Core.db.profile.Debug then
						error("Bad argument to method 'AddButton'. 'Button' must be a button object.", 2)
					end
					return
				end
				if Group[Button] == self then
					return
				end
				if Group[Button] then
					Group[Button]:RemoveButton(Button, true)
				end
				Group[Button] = self
				if type(ButtonData) ~= "table" then
					ButtonData = {}
				end
				for Layer, Type in pairs(Layers) do
					if ButtonData[Layer] == nil then
						if Layer == "Shine" then
							ButtonData[Layer] = ButtonData.AutoCast or GetRegion(Button, Layer, Type)
						else
							ButtonData[Layer] = GetRegion(Button, Layer, Type)
						end
					end
				end
				self.Buttons[Button] = ButtonData
				if not self.db.Disabled then
					local db = self.db
					SkinButton(Button, ButtonData, db.SkinID, db.Gloss, db.Backdrop, db.Colors, self.IsActionBar)
				end
			end,

			-- Removes a button from the group and applies the default skin.
			RemoveButton = function(self, Button)
				if Button then
					local ButtonData = self.Buttons[Button]
					Group[Button] = nil
					if ButtonData then
						SkinButton(Button, ButtonData, "Blizzard")
					end
					self.Buttons[Button] = nil
				end
			end,

			-- Deletes the current group and applies the default skin to its buttons.
			Delete = function(self)
				local Subs = self.SubList
				if Subs then
					for Sub in pairs(Subs) do
						Groups[Sub]:Delete()
					end
				end
				for Button in pairs(self.Buttons) do
					Group[Button] = nil
					SkinButton(Button, self.Buttons[Button], "Blizzard")
					self.Buttons[Button] = nil
				end
				if self.Parent then
					self.Parent.SubList[self.ID] = nil
				end
				Core:UpdateOptions(self.Addon, self.Group, true)
				Groups[self.ID] = nil
			end,

			-- Reskins the group with its current settings.
			ReSkin = function(self)
				if not self.db.Disabled then
					local db = self.db
					for Button in pairs(self.Buttons) do
						SkinButton(Button, self.Buttons[Button], db.SkinID, db.Gloss, db.Backdrop, db.Colors, self.IsActionBar)
					end
					if self.Addon then
						FireCB(self.Addon, self.Group, db.SkinID, db.Gloss, db.Backdrop, db.Colors)
					end
				end
			end,

            ReSkinWithSub = function(self)
                self:ReSkin()
                local Subs = self.SubList
                if Subs then
                    for Sub in pairs(Subs) do
                        Groups[Sub]:ReSkinWithSub()
                    end
                end
            end,

			-- Returns a button layer.
			GetLayer = function(self, Button, Layer)
				if Button and Layer then
					local ButtonData = self.Buttons[Button]
					if ButtonData then
						return ButtonData[Layer]
					end
				end
			end,

			-- Returns a layer color.
			GetColor = function(self, Layer)
				local Skin = Skins[self.db.SkinID] or Skins["Blizzard"]
				return GetColor(self.db.Colors[Layer] or Skin[Layer].Color)
			end,

			-- [ Private Methods ] --

			-- These methods are for internal use only. Don't use them.

			-- Disables the group.
			Disable = function(self)
				self.db.Disabled = true
				for Button in pairs(self.Buttons) do
					SkinButton(Button, self.Buttons[Button], "Blizzard")
				end
				local db = self.db
				FireCB(self.Addon, self.Group, db.SkinID, db.Gloss, db.Backdrop, db.Colors, true)
				local Subs = self.SubList
				if Subs then
					for Sub in pairs(Subs) do
						Groups[Sub]:Disable()
					end
				end
			end,

			-- Enables the group.
			Enable = function(self)
				self.db.Disabled = false
				self:ReSkin()
				local Subs = self.SubList
				if Subs then
					for Sub in pairs(Subs) do
						Groups[Sub]:Enable()
					end
				end
			end,

			-- Validates and sets a skin option.
			SetOption = function(self, Option, Value)
				if Option == "SkinID" then
					if Value and SkinList[Value] then
						self.db.SkinID = Value
					end
				elseif Option == "Gloss" then
					if type(Value) ~= "number" then
						Value = (Value and 1) or 0
					end
					self.db.Gloss = Value
				elseif Option == "Backdrop" then
					self.db.Backdrop = (Value and true) or false
				else
					return
				end
				self:ReSkin()
				local Subs = self.SubList
				if Subs then
					for Sub in pairs(Subs) do
						Groups[Sub]:SetOption(Option, Value)
					end
				end
			end,

			-- Sets the specified layer color.
			SetColor = function(self, Layer, r, g, b, a)
				if not Layer then return end
				if r then
					self.db.Colors[Layer] = {r, g, b, a}
				else
					self.db.Colors[Layer] = nil
				end
				self:ReSkin()
				local Subs = self.SubList
				if Subs then
					for Sub in pairs(Subs) do
						Groups[Sub]:SetColor(Layer, r, g, b, a)
					end
				end
			end,

			-- Resets the group's skin back to its defaults.
			Reset = function(self)
				self.db.Gloss = 0
				self.db.Backdrop = false
				for Layer in pairs(self.db.Colors) do
					self.db.Colors[Layer] = nil
				end
				self:ReSkin()
				local Subs = self.SubList
				if Subs then
					for Sub in pairs(Subs) do
						Groups[Sub]:Reset()
					end
				end
			end,

			-- Updates the group on profile activity, etc.
			Update = function(self, Limit)
				self.db = Core.db.profile.Groups[self.ID]
				if self.Parent then
					local db = self.Parent.db
					if self.db.Inherit and self.db.SkinID ~= db.SkinID then
						self.db.SkinID = db.SkinID
						self.db.Gloss = db.Gloss
						self.db.Backdrop = db.Backdrop
						for Layer in pairs(self.db.Colors) do
							self.db.Colors[Layer] = nil
						end
						for Layer in pairs(db.Colors) do
							if type(db.Colors[Layer]) == "table" then
								local r, g, b, a = unpack(db.Colors[Layer])
								self.db.Colors[Layer] = {r, g, b, a}
							end
						end
						self.db.Inherit = false
					end
					if db.Disabled then
						self.db.Disabled = true
					end
				end
				if self.db.Disabled then
					for Button in pairs(self.Buttons) do
						SkinButton(Button, self.Buttons[Button], "Blizzard")
					end
				else
					self:ReSkin()
				end
				if not Limit then
					local Subs = self.SubList
					if Subs then
						for Sub in pairs(Subs) do
							Groups[Sub]:Update()
						end
					end
				end
			end,

			-- Returns an Ace3 options table for the group.
			GetOptions = function(self)
				return Core:GetOptions(self.Addon, self.Group)
			end,
		}
	}
end
