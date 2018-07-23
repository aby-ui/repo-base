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
	Mouseover.lua
	Grid status module for mouseover units.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L
local GridRoster = Grid:GetModule("GridRoster")

local GridStatusMouseover = Grid:NewStatusModule("GridStatusMouseover")
GridStatusMouseover.menuName = L["Mouseover"]
GridStatusMouseover.options = false

GridStatusMouseover.defaultDB = {
	mouseover = {
		enable = true,
		priority = 50,
		color = { r = 1, g = 1, b = 1, a = 1 },
		text = L["Mouseover"],
	}
}

function GridStatusMouseover:PostInitialize()
	self:Debug("PostInitialize")
	self:RegisterStatus("mouseover", L["Mouseover"], nil, true)
end

function GridStatusMouseover:OnStatusEnable(status)
	self:Debug("OnStatusEnable", status)
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "UpdateAllUnits")
	self:RegisterMessage("Grid_RosterUpdated", "UpdateAllUnits")
	self:UpdateAllUnits()
end

function GridStatusMouseover:OnStatusDisable(status)
	self:Debug("OnStatusDisable", status)
	self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:UnregisterMessage("Grid_RosterUpdated")
	self:SendStatusLostAllUnits(status)
end

local updater, t = CreateFrame("Frame"), 0.1
updater:Hide()
updater:SetScript("OnUpdate", function(self, elapsed)
	t = t - elapsed
	if t <= 0 then
		local guid = UnitGUID("mouseover")
		if not guid then
			GridStatusMouseover.core:SendStatusLostAllUnits("mouseover")
			return self:Hide()
		end
		t = 0.1
	end
end)

function GridStatusMouseover:UpdateAllUnits(event)
	local profile = self.db.profile.mouseover
	local mouseover = UnitGUID("mouseover")
	if not mouseover then
		return self.core:SendStatusLostAllUnits("mouseover")
	end
	for guid, unit in GridRoster:IterateRoster() do
		if guid == mouseover then
			self.core:SendStatusGained(guid, "mouseover",
				profile.priority,
				nil,
				profile.color,
				profile.text
			)
			updater:Show()
		else
			self.core:SendStatusLost(guid, "mouseover")
		end
	end
end
