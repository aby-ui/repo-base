--[[
	qualityFilter.lua
		A set of buttons to choose what quality of items to show
--]]

local ADDON, Addon = ...
local QualityFilter = Addon.Parented:NewClass('QualityFilter', 'Frame')
QualityFilter.Button = Addon.QualityButton


--[[ Constructor ]]--

function QualityFilter:New(parent)
	local f = self:Super(QualityFilter):New(parent)
	f:SetSize(self.Button.SIZE * (Addon.IsRetail and 8 or 6), self.Button.SIZE)
	f:AddQualityButton(0)
	f:AddQualityButton(1)
	f:AddQualityButton(2)
	f:AddQualityButton(3)
	f:AddQualityButton(4)
	f:AddQualityButton(5)

	if Addon.IsRetail then
		f:AddQualityButton(6)
		f:AddQualityButton(7)
	end

	return f
end

function QualityFilter:AddQualityButton(quality, color)
	local button = self.Button:New(self, quality)
	if self.prev then
		button:SetPoint('LEFT', self.prev, 'RIGHT', 1, 0)
	else
		button:SetPoint('LEFT', 0, 2)
	end

	self.prev = button
end
