--[[
	Copyright (C) 2006-2007 Nymbia
	Copyright (C) 2010-2017 Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along
	with this program; if not, write to the Free Software Foundation, Inc.,
	51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]
local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")

local QuartzStatusBar = CreateFrame("Frame")
local MetaTable = {__index = QuartzStatusBar}

QuartzStatusBar.__min = 0
QuartzStatusBar.__max = 100
QuartzStatusBar.__value = 0
QuartzStatusBar.__orientation = "HORIZONTAL"
QuartzStatusBar.__rotatesTexture = 1

local DrawBar, UpdateBarValue

function Quartz3:CreateStatusBar(name, parent)
	local bar = setmetatable(CreateFrame("Frame", name, parent), MetaTable)
	bar.__texture = bar:CreateTexture(nil, "ARTWORK")
	bar.__texture:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])

	DrawBar(bar)

	return bar
end

function DrawBar(self)
	self.__texture:ClearAllPoints()
	self.__texture:SetPoint("TOPLEFT", self, "TOPLEFT")
	if self.__orientation == "HORIZONTAL" then
		self.__texture:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
	elseif self.__orientation == "VERTICAL" then
		self.__texture:SetPoint("TOPRIGHT", self, "TOPRIGHT")
	end
	local r, g, b, a = 1, 1, 1, 1
	if self.__color then
		if #self.__color == 3 then
			r, g, b = unpack(self.__color)
		elseif #self.__color == 4 then
			r, g, b, a = unpack(self.__color)
		end
	end
	self.__texture:SetVertexColor(r, g, b, a)
	UpdateBarValue(self)
end

function UpdateBarValue(self)
	local perc = 0
	if self.__max ~= self.__min then
		perc = (self.__value - self.__min) / (self.__max - self.__min)
	end
	perc = min(max(perc, 0), 1)
	local width = self:GetWidth()
	self.__texture:SetPoint("RIGHT", self, "LEFT", perc * width, 0)
	self.__texture:SetTexCoord(0, perc, 0, 1)
end

function QuartzStatusBar:GetMinMaxValues()
	return self.__min, self.__max
end

function QuartzStatusBar:SetMinMaxValues(min, max)
	if not tonumber(min) or not tonumber(max) then
		return error(format("QuartzStatusBar:SetMinMaxValues(min, max): Invalid min or max specified! Values were: %q, %q", min, max), 2)
	end
	self.__min = tonumber(min)
	self.__max = tonumber(max)
	UpdateBarValue(self)
end

function QuartzStatusBar:GetValue()
	return self.__value
end

function QuartzStatusBar:SetValue(value)
	if not tonumber(value) then
		return error(format("QuartzStatusBar:SetValue(value): Invalid value specified! Value was: %q", value), 2)
	end
	self.__value = tonumber(value)
	UpdateBarValue(self)
end


function QuartzStatusBar:GetOrientation()
	return self.__orientation
end

function QuartzStatusBar:SetOrientation(orientation)
	if orientation ~= "HORIZONTAL" and orientation ~= "VERTICAL" then
		return error("QuartzStatusBar:SetOrientation(orientation): Only HORIZONTAL and VERTICAL orientations supported!", 2)
	end
	self.__orientation = orientation
	DrawBar(self)
end

function QuartzStatusBar:GetRotatesTexture()
	return self.__rotatesTexture
end

function QuartzStatusBar:SetRotatesTexture(rotate)
	self.__rotatesTexture = rotate and 1 or nil
	DrawBar(self)
end

function QuartzStatusBar:GetStatusBarColor()
	return unpack(self.__color)
end

function QuartzStatusBar:SetStatusBarColor(r, g, b, a)
	if not (r and g and b) then
		error("Usage: SetStatusBarColor(r, g, b[, a])", 2)
	end
	self.__color = {r, g, b, a}
	DrawBar(self)
end

function QuartzStatusBar:GetStatusBarTexture()
	return self.__texture
end

function QuartzStatusBar:SetStatusBarTexture(texture, layer)
	if type(texture) == "string" then
		self.__texture:SetTexture(texture)
	elseif type(texture) == "table" then
		self.__texture = texture
	end
	self.__texture:SetDrawLayer(layer or "ARTWORK")
end
