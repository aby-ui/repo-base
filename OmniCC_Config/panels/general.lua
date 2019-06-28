--[[
	General configuration settings for OmniCC
--]]
local GeneralOptions = CreateFrame("Frame", "OmniCCOptions_General")
local OmniCC = _G.OmniCC
local Sets = OmniCC.sets

local L = _G.OMNICC_LOCALS
local SUBSECONDS_ABBR = "%.1f" .. (SECONDS_ABBR:match("%%d(.+)"))
local MINUTES_ABBR = "%.1f" .. (MINUTES_ABBR:match("%%d(.+)"))
local BUTTON_SPACING = 8
local SLIDER_SPACING = 24

function GeneralOptions:AddWidgets()
	local enableCDText = self:CreateEnableTextCheckbox()
	enableCDText:SetPoint("TOPLEFT", self, "TOPLEFT", 12, -10)

	local scaleText = self:CreateScaleTextCheckbox()
	scaleText:SetPoint("TOPLEFT", enableCDText, "BOTTOMLEFT", 0, -BUTTON_SPACING)

	local finishEffect = self:CreateFinishEffectPicker()
	finishEffect:SetPoint("TOPLEFT", scaleText, "BOTTOMLEFT", 4, -BUTTON_SPACING)

	--sliders
	-- local spiralOpacity = self:CreateSpiralOpacitySlider()
	-- spiralOpacity:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 16, 10)
	-- spiralOpacity:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -16, 10)

	local minEffectDuration = self:CreateMinEffectDurationSlider()
	minEffectDuration:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 16, 10)
	minEffectDuration:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -16, 10)

	local mmSSDuration = self:CreateMMSSSlider()
	mmSSDuration:SetPoint("BOTTOMLEFT", minEffectDuration, "TOPLEFT", 0, SLIDER_SPACING)
	mmSSDuration:SetPoint("BOTTOMRIGHT", minEffectDuration, "TOPRIGHT", 0, SLIDER_SPACING)

	local tenthsDuration = self:CreateTenthsSlider()
	tenthsDuration:SetPoint("BOTTOMLEFT", mmSSDuration, "TOPLEFT", 0, SLIDER_SPACING)
	tenthsDuration:SetPoint("BOTTOMRIGHT", mmSSDuration, "TOPRIGHT", 0, SLIDER_SPACING)

	local minDuration = self:CreateMinDurationSlider()
	minDuration:SetPoint("BOTTOMLEFT", tenthsDuration, "TOPLEFT", 0, SLIDER_SPACING)
	minDuration:SetPoint("BOTTOMRIGHT", tenthsDuration, "TOPRIGHT", 0, SLIDER_SPACING)

	local minSize = self:CreateMinSizeSlider()
	minSize:SetPoint("BOTTOMLEFT", minDuration, "TOPLEFT", 0, SLIDER_SPACING)
	minSize:SetPoint("BOTTOMRIGHT", minDuration, "TOPRIGHT", 0, SLIDER_SPACING)
end

function GeneralOptions:UpdateValues()
	if self.buttons then
		for i, b in pairs(self.buttons) do
			b:UpdateChecked()
		end
	end

	if self.sliders then
		for i, s in pairs(self.sliders) do
			s:UpdateValue()
		end
	end

	if self.dropdowns then
		for i, dd in pairs(self.dropdowns) do
			dd:UpdateValue()
		end
	end
end

function GeneralOptions:GetGroupSets()
	return OmniCCOptions:GetGroupSets()
end

function GeneralOptions:NewCheckbox(name)
	local b = OmniCCOptions.CheckButton:New(name, self)

	self.buttons = self.buttons or {}
	table.insert(self.buttons, b)
	return b
end

--scale text
function GeneralOptions:CreateEnableTextCheckbox()
	local parent = self
	local b = self:NewCheckbox(L.EnableText)

	b.OnEnableSetting = function(self, enable)
		parent:GetGroupSets().enabled = enable
	end

	b.IsSettingEnabled = function(self)
		return parent:GetGroupSets().enabled
	end

	b.tooltip = L.EnableTextTip

	return b
end

--scale text
function GeneralOptions:CreateScaleTextCheckbox()
	local parent = self
	local b = self:NewCheckbox(L.ScaleText)

	b.OnEnableSetting = function(self, enable)
		parent:GetGroupSets().scaleText = enable
		OmniCC.Display:ForActive("UpdateCooldownTextStyle")
	end

	b.IsSettingEnabled = function(self)
		return parent:GetGroupSets().scaleText
	end

	b.tooltip = L.ScaleTextTip

	return b
end

function GeneralOptions:NewSlider(name, low, high, step)
	local s = OmniCCOptions.Slider:New(name, self, low, high, step)

	s:SetHeight(s:GetHeight() + 2)

	self.sliders = self.sliders or {}
	table.insert(self.sliders, s)
	return s
end

function GeneralOptions:CreateMinDurationSlider()
	local parent = self
	local s = self:NewSlider(L.MinDuration, 0, 30, 0.1)

	s.SetSavedValue = function(self, value)
		parent:GetGroupSets().minDuration = value
	end

	s.GetSavedValue = function(self)
		return parent:GetGroupSets().minDuration
	end

	s.GetFormattedText = function(self, value)
		return SUBSECONDS_ABBR:format(value)
	end

	s.tooltip = L.MinDurationTip

	return s
end

function GeneralOptions:CreateMinSizeSlider()
	local parent = self
	local s = self:NewSlider(L.MinSize, 0, 200, 1)

	s.SetSavedValue = function(_, value)
		parent:GetGroupSets().minSize = value / 100
		OmniCC.Display:ForAll("UpdateCooldownTextShown")
	end

	s.GetSavedValue = function(_)
		return floor(parent:GetGroupSets().minSize * 100)
	end

	s.tooltip = L.MinSizeTip

	return s
end

function GeneralOptions:CreateMinEffectDurationSlider()
	local parent = self
	local s = self:NewSlider(L.MinEffectDuration, 0, 60, 0.1)

	s.SetSavedValue = function(self, value)
		parent:GetGroupSets().minEffectDuration = value
	end

	s.GetSavedValue = function(self)
		return parent:GetGroupSets().minEffectDuration
	end

	s.GetFormattedText = function(self, value)
		return SUBSECONDS_ABBR:format(value)
	end

	s.tooltip = L.MinEffectDurationTip

	return s
end

function GeneralOptions:CreateMMSSSlider()
	local parent = self
	local s = self:NewSlider(L.MMSSDuration, 1, 15, 0.1)

	s.SetSavedValue = function(self, value)
		if value > 1 then
			parent:GetGroupSets().mmSSDuration = value * 60
		else
			parent:GetGroupSets().mmSSDuration = 0
		end

		OmniCC.Timer:ForActive("Update")
	end

	s.GetSavedValue = function(self)
		if parent:GetGroupSets().mmSSDuration > 60 then
			return parent:GetGroupSets().mmSSDuration / 60
		end
		return 1
	end

	s.GetFormattedText = function(self, value)
		if value > 1 then
			return MINUTES_ABBR:format(value)
		end
		return NEVER
	end

	s.tooltip = L.MMSSDurationTip

	return s
end

function GeneralOptions:CreateTenthsSlider()
	local parent = self
	local s = self:NewSlider(L.TenthsDuration, 0, 10, 0.1)

	s.SetSavedValue = function(self, value)
		parent:GetGroupSets().tenthsDuration = value

		OmniCC.Timer:ForActive("Update")
	end

	s.GetSavedValue = function(self)
		return parent:GetGroupSets().tenthsDuration
	end

	s.GetFormattedText = function(self, value)
		if value > 0 then
			return SUBSECONDS_ABBR:format(value)
		end
		return NEVER
	end

	s.tooltip = L.TenthsDurationTip

	return s
end

-- function GeneralOptions:CreateSpiralOpacitySlider()
-- 	local parent = self
-- 	local s = self:NewSlider(L.SpiralOpacity, 0, 1, .01)

-- 	s.SetSavedValue = function(self, value)
-- 		parent:GetGroupSets().spiralOpacity = value
-- 		-- Cooldown:ForAll("UpdateAlpha")
-- 	end

-- 	s.GetSavedValue = function(self)
-- 		return parent:GetGroupSets().spiralOpacity
-- 	end

-- 	s.GetFormattedText = function(self, value)
-- 		return floor(value * 100) .. "%"
-- 	end

-- 	s.tooltip = L.SpiralOpacityTip
-- 	return s
-- end

function GeneralOptions:CreateFinishEffectPicker()
	local dd =
		_G.OmniCCOptions.Dropdown:New {
		parent = self,
		name = L.FinishEffect,
		get = function()
			return self:GetGroupSets().effect
		end,
		set = function(_, value)
			self:GetGroupSets().effect = value
		end,
		items = function()
			local t = {}

			for id, effect in OmniCC.FX:All() do
				tinsert(t, {
					text = effect.name,
					tooltip = effect.desc,
					value = id
				})
			end

			return t
		end
	}

	return dd
end

OmniCCOptions:AddTab("general", L.GeneralSettings, GeneralOptions)
GeneralOptions:AddWidgets()
GeneralOptions:UpdateValues()
