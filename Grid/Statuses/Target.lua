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
	Target.lua
	Grid status module for tracking the player's target and focus target.
	Created by noha, modified by Pastamancer and Phanx.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local currentTarget, currentFocus

local GridStatusTarget = Grid:NewStatusModule("GridStatusTarget")
GridStatusTarget.menuName = L["Target"]
GridStatusTarget.options = false

GridStatusTarget.defaultDB = {
	player_target = {
		text = L["Target"],
		enable = true,
		color = { r = 0.8, g = 0.8, b = 0.8, a = 0.8 },
		priority = 69,
	},
	player_focus = {
		text = L["Focus"],
		enable = true,
		color = { r = 0.8, g = 0.8, b = 0.8, a = 0.8 },
		priority = 49,
	},
}


function GridStatusTarget:PostInitialize()
	self:RegisterStatus("player_target", L["Your Target"], nil, true)
	self:RegisterStatus("player_focus", L["Your Focus"], nil, true)
end

function GridStatusTarget:OnStatusEnable(status)
	if status == "player_target" then
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:PLAYER_TARGET_CHANGED()
	elseif status == "player_focus" then
		self:RegisterEvent("PLAYER_FOCUS_CHANGED")
		self:PLAYER_FOCUS_CHANGED()
	end
end

function GridStatusTarget:OnStatusDisable(status)
	if status == "player_target" then
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self.core:SendStatusLostAllUnits("player_target")
	elseif status == "player_focus" then
		self:UnregisterEvent("PLAYER_FOCUS_CHANGED")
		self.core:SendStatusLostAllUnits("player_focus")
	end
end

function GridStatusTarget:PLAYER_TARGET_CHANGED()
	local settings = self.db.profile.player_target

	if currentTarget then
		self.core:SendStatusLost(currentTarget, "player_target")
	end

	if UnitExists("target") and settings.enable then
		currentTarget = UnitGUID("target")
		self.core:SendStatusGained(currentTarget, "player_target",
			settings.priority,
			settings.range,
			settings.color,
			settings.text,
			nil,
			nil,
			settings.icon)
	end
end

function GridStatusTarget:PLAYER_FOCUS_CHANGED()
	local settings = self.db.profile.player_focus

	if currentFocus then
		self.core:SendStatusLost(currentFocus, "player_focus")
	end

	if UnitExists("focus") and settings.enable then
		currentFocus = UnitGUID("focus")
		self.core:SendStatusGained(currentFocus, "player_focus",
			settings.priority,
			settings.range,
			settings.color,
			settings.text,
			nil,
			nil,
			settings.icon)
	end
end
