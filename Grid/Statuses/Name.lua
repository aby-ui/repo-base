--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
------------------------------------------------------------------------
	Name.lua
	Grid status module for unit names.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local GridRoster = Grid:GetModule("GridRoster")

local GridStatusName = Grid:NewStatusModule("GridStatusName")
GridStatusName.menuName = L["Unit Name"]
GridStatusName.options = false

GridStatusName.defaultDB = {
	unit_name = {
		enable = true,
		priority = 1,
		text = L["Unit Name"],
		color = { r = 1, g = 1, b = 1, a = 1 },
		class = true,
	},
}

local nameOptions = {
	class = {
		name = L["Use class color"],
		desc = L["Color by class"],
		type = "toggle", width = "double",
		get = function()
			return GridStatusName.db.profile.unit_name.class
		end,
		set = function()
			GridStatusName.db.profile.unit_name.class = not GridStatusName.db.profile.unit_name.class
			GridStatusName:UpdateAllUnits()
		end,
	}
}

local classIconCoords = {}
for class, t in pairs(CLASS_ICON_TCOORDS) do
	local offset, left, right, bottom, top = 0.025, unpack(t)
	classIconCoords[class] = {
		left   = left   + offset,
		right  = right  - offset,
		bottom = bottom + offset,
		top    = top    - offset,
	}
end

function GridStatusName:PostInitialize()
	self:RegisterStatus("unit_name", L["Unit Name"], nameOptions, true)
end

function GridStatusName:OnStatusEnable(status)
	if status ~= "unit_name" then return end

	self:RegisterEvent("UNIT_NAME_UPDATE", "UpdateUnit")
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE", "UpdateUnit")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "UpdateVehicle")
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "UpdateVehicle")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateAllUnits")

	self:RegisterMessage("Grid_UnitJoined", "UpdateGUID")
	self:RegisterMessage("Grid_UnitChanged", "UpdateGUID")
	self:RegisterMessage("Grid_UnitLeft", "UpdateGUID")

	self:RegisterMessage("Grid_ColorsChanged", "UpdateAllUnits")

	self:UpdateAllUnits()
end

function GridStatusName:OnStatusDisable(status)
	if status ~= "unit_name" then return end

	self:UnregisterEvent("UNIT_NAME_UPDATE")
	self:UnregisterEvent("UNIT_PORTRAIT_UPDATE")
	self:UnregisterEvent("UNIT_ENTERED_VEHICLE")
	self:UnregisterEvent("UNIT_EXITED_VEHICLE")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	self:UnregisterMessage("Grid_UnitJoined")
	self:UnregisterMessage("Grid_UnitChanged")
	self:UnregisterMessage("Grid_UnitLeft")
	self:UnregisterMessage("Grid_ColorsChanged")

	self.core:SendStatusLostAllUnits("unit_name")
end

function GridStatusName:UpdateVehicle(event, unitid)
	self:UpdateUnit(event, unitid)
	local pet_unit = unitid .. "pet"
	if UnitExists(pet_unit) then
		self:UpdateUnit(event, pet_unit)
	end
end

function GridStatusName:UpdateUnit(event, unitid)
	local guid = unitid and UnitGUID(unitid)
	if guid then
		self:UpdateGUID(event, guid)
	end
end

function GridStatusName:UpdateGUID(event, guid)
	local settings = self.db.profile.unit_name

	local name = GridRoster:GetNameByGUID(guid)
	if not name or not settings.enable then return end

	local unitid = GridRoster:GetUnitidByGUID(guid)
	local _, class = UnitClass(unitid)

	-- show player name instead of vehicle name
	local owner_unitid = GridRoster:GetOwnerUnitidByUnitid(unitid)
	if owner_unitid and UnitHasVehicleUI(owner_unitid) then
		local owner_guid = UnitGUID(owner_unitid)
		name = GridRoster:GetNameByGUID(owner_guid)
	end

	self.core:SendStatusGained(guid, "unit_name",
		settings.priority,
		nil,
		settings.class and self.core:UnitColor(guid) or settings.color,
		name,
		nil,
		nil,
		class and [[Interface\Glues\CharacterCreate\UI-CharacterCreate-Classes]] or nil,
		nil,
		nil,
		nil,
		class and classIconCoords[class] or nil)
end

function GridStatusName:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:UpdateGUID("UpdateAllUnits", guid)
	end
end
