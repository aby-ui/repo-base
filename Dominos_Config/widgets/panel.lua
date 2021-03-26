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

function Panel:NewLayerSlider(options)
	options.parent = self

	local slider = Addon.LayerSlider:New(options)

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

local DISPLAY_LAYER_OPTIONS = {"BACKGROUND", "LOW", "MEDIUM", "HIGH"}

function Panel:NewDisplayLayerSlider(options)
	local slider = self:NewSlider{
		name = L.FrameStrata,

		min = 1,

		max = function()
			return #DISPLAY_LAYER_OPTIONS
		end,

		get = function()
			local value = self.owner:GetDisplayLayer()

			for i, layer in pairs(DISPLAY_LAYER_OPTIONS) do
				if layer == value then
					return i
				end
			end

			return 1
		end,

		set = function(_, value)
			self.owner:SetDisplayLayer(DISPLAY_LAYER_OPTIONS[value])
		end,

		format = function(_, value)
			local layer = DISPLAY_LAYER_OPTIONS[value]
			return L["FrameStrata_" .. layer]
		end
	}

	slider.valText:SetScript("OnTextChanged", nil)
	slider.valText:SetScript("OnEditFocusGained", nil)
	slider.valText:SetScript("OnEditFocusLost", nil)
	slider.valText:SetScript("OnEscapePressed", nil)
	slider.valText:SetScript("OnEnterPressed", nil)
	slider.valText:SetScript("OnTabPressed", nil)
	slider.valText:SetWidth(slider.valText:GetWidth() + 64)
	slider.valText:Disable()

	return slider
end


function Panel:NewDisplayLevelSlider(options)
	return self:NewSlider{
		name = L.FrameLevel,

		min = 1,

		max = 200,

		get = function()
			return self.owner:GetDisplayLevel() or 1
		end,

		set = function(_, value)
			self.owner:SetDisplayLevel(value)
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

function Panel:NewFadeDelaySlider(smoothType)
    return self:NewSlider({
		name = L.Delay,
		min = 0,
		max = 10,
		step = 0.1,
		format = "%.1f",
        get = smoothType == "IN" and function() return self.owner:GetFadeInDelay() end or
            function() return self.owner:GetFadeOutDelay() end,
        set = smoothType == "IN" and function(_, value) self.owner:SetFadeInDelay(value) end or
            function(_, value) self.owner:SetFadeOutDelay(value) end,
    })
end

function Panel:NewFadeDurationSlider(smoothType)
    return self:NewSlider({
        name = L.Duration,
		min = 0.1,
		max = 10,
		step = 0.1,
		format = "%.1f",
        get = smoothType == "IN" and function() return self.owner:GetFadeInDuration() end or
            function() return self.owner:GetFadeOutDuration() end,
        set = smoothType == "IN" and function(_, value) self.owner:SetFadeInDuration(value) end or
            function(_, value) self.owner:SetFadeOutDuration(value) end,
    })
end

function Panel:AddLayoutOptions()
	self.colsSlider = self:NewColumnsSlider()
	self.spacingSlider = self:NewSpacingSlider()
	self:AddBasicLayoutOptions()
end

function Panel:AddBasicLayoutOptions()
	self.paddingSlider = self:NewPaddingSlider()
	self.scaleSlider = self:NewScaleSlider()
	self.displayLayerSlider = self:NewDisplayLayerSlider()
	self.displayLevelSlider = self:NewDisplayLevelSlider()
end

function Panel:AddAdvancedOptions(displayConditionsOnly)
	if not displayConditionsOnly then
		self:NewLeftToRightCheckbox()
		self:NewTopToBottomCheckbox()
		self:NewClickThroughCheckbox()
	end

	if ParentAddon:IsBuild("retail") then
		self:NewShowInOverrideUICheckbox()
		self:NewShowInPetBattleUICheckbox()
	end

	self.showStatesEditBox = self:NewTextInput{
		name = L.ShowStates,
		multiline = true,
		width = 268,
		height = 64,
		get = function() return self.owner:GetUserDisplayConditions() end,
		set = function(_, value) self.owner:SetUserDisplayConditions(value) end
	}
end

function Panel:AddFadingOptions()
	self:NewHeader(L.FadeIn)
	self:NewOpacitySlider()
	self:NewFadeDelaySlider("IN")
	self:NewFadeDurationSlider("IN")

    self:NewHeader(L.FadeOut)
    self:NewFadeSlider()
	self:NewFadeDelaySlider("OUT")
	self:NewFadeDurationSlider("OUT")
end

Addon.Panel = Panel
