--[[ a generic widget for holding stuff ]]--

local AddonName, Addon = ...
local Panel = Addon:CreateClass('Frame')
local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')
local ParentAddonName = GetAddOnDependencies(AddonName)
local ParentAddon = _G[ParentAddonName]

local max = math.max
local round = function(v) return math.floor(v + 0.5) end
local MIN_WIDTH = 276
local MIN_HEIGHT = 330

Panel.width = 0
Panel.height = 0

function Panel:New(parent)
	return self:Bind(CreateFrame('Frame', nil, parent))
end

function Panel:SetOwner(owner)
	self.owner = owner
end

function Panel:GetOwner()
	return self.owner
end

function Panel:Render()
	self:SetSize(max(self.width, MIN_WIDTH), max(self.height, MIN_HEIGHT))
	Addon:Render(self)
end

function Panel:OnRender()
	self:SetSize(max(self.width, MIN_WIDTH), max(self.height, MIN_HEIGHT))
end

--[[ generic widgets ]]--

function Panel:Add(widget, options)
	options = options or {}
	options.parent = self

	return Addon[widget]:New(options)
end

function Panel:NewHeader(name)
	local frame = CreateFrame('Frame', nil, self)

	local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	text:SetJustifyH('LEFT')
	text:SetPoint('BOTTOMLEFT', 0, 1)
	text:SetText(name)

	local border = frame:CreateTexture(nil, 'ARTWORK')
	border:SetPoint('TOPLEFT', text, 'BOTTOMLEFT')
	border:SetPoint('RIGHT')
	border:SetHeight(1)
	border:SetColorTexture(0.3, 0.3, 0.3, 0.8)

	local prev = self.lastWidget
	if prev then
		frame:SetPoint('TOPLEFT', self.lastWidget, 'BOTTOMLEFT', 0, -4)
	else
		frame:SetPoint('TOPLEFT', 0, -4)
	end
	frame:SetPoint('RIGHT')

	local width, height = text:GetSize()
	frame:SetSize(width + 4, height + 4)

	self.height = self.height + (frame:GetHeight() + 4)
	self.width = max(self.width, frame:GetWidth())
	self.lastWidget = frame

	self:Render()

	return frame
end

function Panel:NewCheckButton(options)
	options.parent = self

	local button = Addon.CheckButton:New(options)

	local prev = self.lastWidget
	if prev then
		button:SetPoint('TOP', self.lastWidget, 'BOTTOM', 0, -2)
	else
		button:SetPoint('TOPLEFT', 0, -2)
	end

	local width, height = button:GetEffectiveSize()
	self.height = self.height + (height + 4)
	self.width = max(self.width, width)
	self.lastWidget = button

	self:Render()

	return button
end

function Panel:NewSlider(options)
	options.parent = self

	local slider = Addon.Slider:New(options)

	local prev = self.lastWidget
	if prev then
		slider:SetPoint('TOPLEFT', self.lastWidget, 'BOTTOMLEFT', 0, -(12 + slider.text:GetHeight()))
	else
		slider:SetPoint('TOPLEFT', 4, -(12 + slider.text:GetHeight()))
	end

	local width, height = slider:GetEffectiveSize()
	self.height = self.height + (height + 12)
	self.width = math.max(self.width, width)
	self.lastWidget = slider

	self:Render()

	return slider
end

function Panel:NewDropdown(options)
	options.parent = self

	local dropdown = Addon.Dropdown:New(options)

	local prev = self.lastWidget
	if prev then
		dropdown:SetPoint('TOPLEFT', self.lastWidget, 'BOTTOMLEFT', 0, -4)
	else
		dropdown:SetPoint('TOPLEFT', 4, -4)
	end
	dropdown:SetPoint('RIGHT')

	local width, height = dropdown:GetEffectiveSize()
	self.height = self.height + (height + 4)
	self.width = math.max(self.width, width)
	self.lastWidget = dropdown

	self:Render()

	return dropdown
end

function Panel:NewTextureSelector(options)
	options.parent = self

	local dropdown = Addon.Dropdown:New(options)

	local prev = self.lastWidget
	if prev then
		dropdown:SetPoint('TOPLEFT', self.lastWidget, 'BOTTOMLEFT', 0, -2)
	else
		dropdown:SetPoint('TOPLEFT', 0, -2)
	end
	dropdown:SetPoint('RIGHT')

	local width, height = dropdown:GetEffectiveSize()
	self.height = self.height + (height + 2)
	self.width = math.max(self.width, width)
	self.lastWidget = dropdown

	self:Render()

	return dropdown
end

function Panel:NewTextInput(options)
	options.parent = self

	local textInput = Addon.TextInput:New(options)

	local prev = self.lastWidget
	if prev then
		textInput:SetPoint('TOPLEFT', self.lastWidget, 'BOTTOMLEFT', 0, -6)
	else
		textInput:SetPoint('TOPLEFT', 0, -6)
	end

	if options.width then
		textInput:SetWidth(options.width)
	else
		textInput:SetPoint('RIGHT')
	end

	textInput:SetHeight(options.height)

	local width, height = textInput:GetEffectiveSize()
	self.height = self.height + (height + 6)
	self.width = math.max(self.width, width)
	self.lastWidget = textInput

	self:Render()

	return textInput
end

--[[ specialized widgets ]]--

function Panel:NewScaleSlider()
	return self:NewSlider{
		name = L.Scale,
		min = 50,
		max = 200,

		get = function()
			return round(self.owner:GetFrameScale() * 100)
		end,

		set = function(_, value)
			self.owner:SetFrameScale(value / 100)
		end
	}
end

function Panel:NewOpacitySlider()
	return self:NewSlider{
		name = L.Opacity,

		get = function()
			return round(self.owner:GetFrameAlpha() * 100)
		end,

		set = function(_, value)
			self.owner:SetFrameAlpha(value / 100)
		end
	}
end

function Panel:NewFadeSlider()
	return self:NewSlider{
		name = L.FadedOpacity,

		get = function()
			return round(self.owner:GetFadeMultiplier() * 100)
		end,

		set = function(_, value)
			self.owner:SetFadeMultiplier(value / 100)
		end
	}
end

function Panel:NewPaddingSlider()
	return self:NewSlider{
		name = L.Padding,
		min = -16,
		max = 32,
		softLimits = true,

		get = function()
			return self.owner:GetPadding()
		end,

		set = function(_, value)
			self.owner:SetPadding(value)
		end
	}
end

function Panel:NewSpacingSlider()
	return self:NewSlider{
		name = L.Spacing,
		min = -16,
		max = 32,
		softLimits = true,

		get = function()
			return self.owner:GetSpacing()
		end,

		set = function(_, value)
			self.owner:SetSpacing(value)
		end
	}
end

function Panel:NewColumnsSlider()
	return self:NewSlider{
		name = L.Columns,

		min = 1,

		max = function()
			return self.owner:NumButtons()
		end,

		get = function()
			return self.owner:NumColumns()
		end,

		set = function(_, value)
			self.owner:SetColumns(value)
		end
	}
end

function Panel:NewLeftToRightCheckbox()
	return self:NewCheckButton{
		name = L.LeftToRight,
		get = function() return self.owner:GetLeftToRight() end,
		set = function(_, enable) self.owner:SetLeftToRight(enable) end
	}
end

function Panel:NewTopToBottomCheckbox()
	return self:NewCheckButton{
		name = L.TopToBottom,
		get = function() return self.owner:GetTopToBottom() end,
		set = function(_, enable) self.owner:SetTopToBottom(enable) end
	}
end

function Panel:NewClickThroughCheckbox()
	return self:NewCheckButton{
		name = L.ClickThrough,
		get = function() return self.owner:GetClickThrough() end,
		set = function(_, enable) self.owner:SetClickThrough(enable) end
	}
end

function Panel:NewShowInOverrideUICheckbox()
	return self:NewCheckButton{
		name = L.ShowInOverrideUI,
		get = function() return self.owner:ShowingInOverrideUI() end,
		set = function(_, enable) self.owner:ShowInOverrideUI(enable) end
	}
end

function Panel:NewShowInPetBattleUICheckbox()
	return self:NewCheckButton{
		name = L.ShowInPetBattleUI,
		get = function() return self.owner:ShowingInPetBattleUI() end,
		set = function(_, enable) self.owner:ShowInPetBattleUI(enable) end
	}
end

function Panel:AddLayoutOptions()
	self.colsSlider = self:NewColumnsSlider()
	self.spacingSlider = self:NewSpacingSlider()
	self.paddingSlider = self:NewPaddingSlider()
	self.scaleSlider = self:NewScaleSlider()
	self.opacitySlider = self:NewOpacitySlider()
	self.fadeSlider = self:NewFadeSlider()
end

function Panel:AddAdvancedOptions()
	self:NewLeftToRightCheckbox()
	self:NewTopToBottomCheckbox()
	self:NewClickThroughCheckbox()

	if ParentAddon:IsBuild("retail") then
		self:NewShowInOverrideUICheckbox()
		self:NewShowInPetBattleUICheckbox()
	end

	self.showStatesEditBox = self:NewTextInput{
		name = L.ShowStates,
		multiline = true,
		width = 268,
		height = 64,
		get = function() return self.owner:GetShowStates() end,
		set = function(_, value) self.owner:SetShowStates(value) end
	}
end

Addon.Panel = Panel