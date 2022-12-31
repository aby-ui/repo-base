--[[
	Frame.lua
		General Bagnon settings
--]]

local _, Addon = ...
local L = Addon.L

local ColorOptions
do
	ColorOptions = Addon.OptionsPanel:New(
		'tullaRange_ColorOptions',
		nil,
		'tullaRange',
		L.ColorSettingsTitle
	)

	-- ColorOptions:Hide()

	Addon.ColorOptions = ColorOptions
end

local SPACING = (SettingsPanel and 16) or 8
local COLOR_TYPES = {'oor', 'oom', 'unusable'}

--[[
	Startup
--]]

function ColorOptions:Load()
	self:SetScript('OnShow', self.OnShow)
	self:AddWidgets()
	self:UpdateWidgets()
end


--[[
	Frame Events
--]]

function ColorOptions:OnShow()
	self:UpdateWidgets()
end


--[[
	Components
--]]

function ColorOptions:AddWidgets()
	local lastSelector = nil

	for i, type in self:GetColorTypes() do
		local selector = self:CreateColorSelector(type)

		selector:SetHeight(160)

		if i == 1 then
			selector:SetPoint('TOPLEFT', 12, -64)
			selector:SetPoint('TOPRIGHT', -12, -64)
		else
			selector:SetPoint('TOPLEFT', lastSelector, 'BOTTOMLEFT', 0, -SPACING)
			selector:SetPoint('TOPRIGHT', lastSelector, 'BOTTOMRIGHT', 0, -SPACING)
		end

		lastSelector = selector
	end
end

function ColorOptions:UpdateWidgets()
	if not self:IsVisible() then
		return
	end

	if self.sliders then
		for _, s in pairs(self.sliders) do
			s:UpdateValue()
		end
	end

	for _, type in self:GetColorTypes() do
		local selector = self:GetColorSelector(type)
		selector:UpdateValues()
	end
end

function ColorOptions:GetColorTypes()
	return pairs(COLOR_TYPES)
end


--[[ Color Pickers ]]--

--frame color
function ColorOptions:CreateColorSelector(type)
	local selector = Addon.ColorSelector:New(type, self)

	local colorSelectors = self.colorSelectors or {}
	colorSelectors[type] = selector
	self.colorSelectors = colorSelectors

	return selector
end

function ColorOptions:GetColorSelector(type)
	return self.colorSelectors and self.colorSelectors[type]
end

--[[ Load the thing ]]--

ColorOptions:Load()