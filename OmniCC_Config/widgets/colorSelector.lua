--[[
	colorSelector.lua
		A bagnon color selector
--]]

OmniCCOptions = OmniCCOptions or {}

local Classy = LibStub('Classy-1.0')
local ColorSelector = Classy:New('Button')
OmniCCOptions.ColorSelector = ColorSelector


--[[ Constructor ]]--

function ColorSelector:New(name, parent, hasOpacity)
	local f = self:Bind(CreateFrame('Button', parent:GetName() .. name, parent))
	f.hasOpacity = hasOpacity
	f:SetWidth(18)
	f:SetHeight(18)

	if hasOpacity then
		f.swatchFunc = function()
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = 1 - OpacitySliderFrame:GetValue()
			f:SetColor(r, g, b, a)
		end

		f.opacityFunc = f.swatchFunc

		f.cancelFunc = function()
			local prev = ColorPickerFrame.previousValues
			f:SetColor(prev.r, prev.g, prev.b, 1 - prev.opacity)
		end
	else
		f.swatchFunc = function()
			f:SetColor(ColorPickerFrame:GetColorRGB())
		end
		f.cancelFunc = function()
			f:SetColor(ColorPicker_GetPreviousValues())
		end
	end

	local nt = f:CreateTexture(nil, 'OVERLAY')
	nt:SetTexture([[Interface\ChatFrame\ChatFrameColorSwatch]])
	nt:SetAllPoints(f)
	f:SetNormalTexture(nt)

	local bg = f:CreateTexture(nil, 'BACKGROUND')
	bg:SetWidth(16)
	bg:SetHeight(16)
	bg:SetColorTexture(1, 1, 1)
	bg:SetPoint('CENTER')
	f.bg = bg

	local text = f:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	text:SetPoint('LEFT', f, 'RIGHT', 4, 0)
	text:SetText(name)
	f.text = text

	f:SetScript('OnClick', f.OnClick)
	f:SetScript('OnEnter', f.OnEnter)
	f:SetScript('OnLeave', f.OnLeave)
	f:SetScript('OnShow', f.OnShow)

	return f
end


--[[ Frame Events ]]--

function ColorSelector:OnClick()
	if ColorPickerFrame:IsShown() then
		ColorPickerFrame:Hide()
	else
		self.r, self.g, self.b, self.opacity = self:GetColor()
		self.opacity = 1 - (self.opacity or 1) --correction, since the color menu is crazy

		OpenColorPicker(self)
		ColorPickerFrame:SetFrameStrata('TOOLTIP')
		ColorPickerFrame:Raise()
	end
end

function ColorSelector:OnShow()
	local r, g, b = self:GetColor()
	self:GetNormalTexture():SetVertexColor(r, g, b)
end

function ColorSelector:OnEnter()
	local color = _G['NORMAL_FONT_COLOR']
	self.bg:SetVertexColor(color.r, color.g, color.b)
end

function ColorSelector:OnLeave()
	local color = _G['HIGHLIGHT_FONT_COLOR']
	self.bg:SetVertexColor(color.r, color.g, color.b)
end


--[[ Update Methods ]]--

function ColorSelector:SetColor(r, g, b, a)
	self:GetNormalTexture():SetVertexColor(r, g, b)
	self:OnSetColor(r, g, b, a)
end

function ColorSelector:OnSetColor(r, g, b, a)
	assert(false, 'Hey, you forgot to implement OnSetColor for ' .. self:GetName())
end

function ColorSelector:GetColor(r, g, b, a)
	assert(false, 'Hey, you forgot to implement GetColor for ' .. self:GetName())
end

function ColorSelector:UpdateColor()
	self:SetColor(self:GetColor())
end