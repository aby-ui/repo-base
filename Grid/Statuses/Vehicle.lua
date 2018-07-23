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
	Vehicle.lua
	Grid status module for showing when a unit is driving a vehicle with a UI.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L
local Roster = Grid:GetModule("GridRoster")

local GridStatusVehicle = Grid:NewStatusModule("GridStatusVehicle")
GridStatusVehicle.menuName = L["In Vehicle"]
GridStatusVehicle.options = false

GridStatusVehicle.defaultDB = {
	alert_vehicleui = {
		enable = true,
		priority = 50,
		text = L["Driving"],
        color = { r = 0, g = 1, b = 0, a = 1, ignore = true },
	},
}

function GridStatusVehicle:PostInitialize()
	self:RegisterStatus("alert_vehicleui", L["In Vehicle"], nil, true)
end

function GridStatusVehicle:OnStatusEnable(status)
	if status ~= "alert_vehicleui" then return end

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateAllUnits")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "UpdateUnit")
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "UpdateUnit")

	self:UpdateAllUnits()
end

function GridStatusVehicle:OnStatusDisable(status)
	if status ~= "alert_vehicleui" then return end

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("UNIT_ENTERED_VEHICLE")
	self:UnregisterEvent("UNIT_EXITED_VEHICLE")

	self.core:SendStatusLostAllUnits("alert_vehicleui")
end

function GridStatusVehicle:UpdateAllUnits()
	for guid, unit in Roster:IterateRoster() do
		self:UpdateUnit("UpdateAllUnits", unit)
	end
end

function GridStatusVehicle:UpdateUnit(event, unit, guid)
	if unit ~= "UpdateAllUnits" then
		guid = UnitGUID(unit)
	end

--	local pet_unit = Roster:GetPetunitByunit(unit)
--	if not pet_unit then return end

--	local guid = UnitGUID(pet_unit)

	if UnitHasVehicleUI(unit) then
		local settings = self.db.profile.alert_vehicleui
		self.core:SendStatusGained(guid, "alert_vehicleui",
			settings.priority,
			nil,
			settings.color,
			settings.text,
			nil,
			nil,
			"Interface\\Vehicles\\UI-Vehicles-Raid-Icon")
	else
		self.core:SendStatusLost(guid, "alert_vehicleui")
	end
end
