--[[
	slider.lua
		A bagnon options slider
--]]

OmniCCOptions = OmniCCOptions or {}

local Slider = LibStub('Classy-1.0'):New('Slider')
OmniCCOptions.Slider = Slider


--[[ Constructor ]]--

function Slider:New(name, parent, low, high, step)
	local f = self:Bind(CreateFrame('Slider', parent:GetName() .. name, parent, 'OptionsSliderTemplate'))
	f:SetMinMaxValues(low, high)
	f:SetValueStep(step)
	f:EnableMouseWheel(true)
	f:SetObeyStepOnDrag(true)

	_G[f:GetName() .. 'Text']:SetText(name)
	_G[f:GetName() .. 'Text']:SetFontObject('GameFontNormalLeft')
	_G[f:GetName() .. 'Text']:ClearAllPoints()
	_G[f:GetName() .. 'Text']:SetPoint('BOTTOMLEFT', f, 'TOPLEFT')
	_G[f:GetName() .. 'Low']:SetText('')
	_G[f:GetName() .. 'High']:SetText('')

	local text = f:CreateFontString(nil, 'BACKGROUND', 'GameFontHighlightSmall')
	text:SetJustifyH('RIGHT')
	text:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT')
	f.valText = text

	f:SetScript('OnShow', f.OnShow)
	f:SetScript('OnMouseWheel', f.OnMouseWheel)
	f:SetScript('OnValueChanged', f.OnValueChanged)
	f:SetScript('OnMouseWheel', f.OnMouseWheel)
	f:SetScript('OnEnter', f.OnEnter)
	f:SetScript('OnLeave', f.OnLeave)

	return f
end


--[[ Frame Events ]]--

function Slider:OnShow()
	self:UpdateValue()
end

function Slider:OnValueChanged(value)
	-- local min = self:GetMinMaxValues()
	-- local step = self:GetValueStep()
	-- local value = min + ceil((value - min) / step) * step

	self:SetSavedValue(value)
	self:UpdateText(self:GetSavedValue())
end

function Slider:OnMouseWheel(direction)
	local step = self:GetValueStep() *  direction
	local value = self:GetValue()
	local minVal, maxVal = self:GetMinMaxValues()

	if step > 0 then
		self:SetValue(min(value+step, maxVal))
	else
		self:SetValue(max(value+step, minVal))
	end
end

function Slider:OnEnter()
	if not GameTooltip:IsOwned(self) and self.tooltip then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		GameTooltip:SetText(self.tooltip)
	end
end

function Slider:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ Update Methods ]]--

function Slider:SetSavedValue(value)
	assert(false, 'Hey, you forgot to set SetSavedValue for ' .. self:GetName())
end

function Slider:GetSavedValue()
	assert(false, 'Hey, you forgot to set GetSavedValue for ' .. self:GetName())
end

function Slider:UpdateValue()
	self:SetValue(self:GetSavedValue())
	self:UpdateText(self:GetSavedValue())
end

function Slider:UpdateText(value)
	if self.GetFormattedText then
		self.valText:SetText(self:GetFormattedText(value))
	else
		self.valText:SetText(value)
	end
end