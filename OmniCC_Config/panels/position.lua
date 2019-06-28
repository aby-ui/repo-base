--[[
	General configuration settings for OmniCC
--]]
local OmniCCOptions = _G.OmniCCOptions
local OmniCC = _G.OmniCC
local L = _G.OMNICC_LOCALS

--fun constants!
local SLIDER_SPACING = 24

local ANCHOR_POINTS = {
	"TOPLEFT",
	"TOP",
	"TOPRIGHT",
	"LEFT",
	"CENTER",
	"RIGHT",
	"BOTTOMLEFT",
	"BOTTOM",
	"BOTTOMRIGHT"
}

local PositionOptions = CreateFrame("Frame", "OmniCCOptions_Position")
PositionOptions:SetScript(
	"OnShow",
	function(self)
		self:AddWidgets()
		self:UpdateValues()
		self:SetScript("OnShow", nil)
	end
)

function PositionOptions:GetGroupSets()
	return OmniCCOptions:GetGroupSets()
end

function PositionOptions:AddWidgets()
	--dropdowns
	local anchor = self:CreateAnchorPicker()
	anchor:SetPoint("TOPLEFT", self, "TOPLEFT", 12, -26)
	anchor:SetSize(592, 380)
	anchor:Layout()

	--sliders
	local yOff = self:CreateYOffsetSlider()
	yOff:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 16, 10)
	yOff:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -16, 10)

	local xOff = self:CreateXOffsetSlider()
	xOff:SetPoint("BOTTOMLEFT", yOff, "TOPLEFT", 0, SLIDER_SPACING)
	xOff:SetPoint("BOTTOMRIGHT", yOff, "TOPRIGHT", 0, SLIDER_SPACING)
end

function PositionOptions:UpdateValues()
	self.anchorPicker:UpdateValue()

	if self.sliders then
		for _, s in pairs(self.sliders) do
			s:UpdateValue()
		end
	end
end

function PositionOptions:NewSlider(name, low, high, step)
	local s = OmniCCOptions.Slider:New(name, self, low, high, step)
	s:SetHeight(s:GetHeight() + 2)

	self.sliders = self.sliders or {}
	table.insert(self.sliders, s)
	return s
end

function PositionOptions:CreateXOffsetSlider()
	local parent = self
	local s = self:NewSlider(L.XOffset, -32, 32, 1)

	s.SetSavedValue = function(self, value)
		parent:GetGroupSets().xOff = value
		OmniCC.Display:ForAll("UpdateCooldownTextPosition")
	end

	s.GetSavedValue = function(self)
		return parent:GetGroupSets().xOff
	end

	s.tooltip = L.XOffsetTip

	return s
end

function PositionOptions:CreateYOffsetSlider()
	local parent = self
	local s = self:NewSlider(L.YOffset, -32, 32, 1)

	s.SetSavedValue = function(self, value)
		parent:GetGroupSets().yOff = value
		OmniCC.Display:ForAll("UpdateCooldownTextPosition")
	end

	s.GetSavedValue = function(self)
		return parent:GetGroupSets().yOff
	end

	s.tooltip = L.YOffsetTip

	return s
end

function PositionOptions:CreateAnchorPicker()
	local parent = self
	local rg = OmniCCOptions.RadioGroup:New(L.Anchor, parent)

	for i, v in ipairs(ANCHOR_POINTS) do
		rg:AddItem(v, L["Anchor_" .. v])
	end

	rg.OnSelect = function(self, value)
		parent:GetGroupSets().anchor = value
		OmniCC.Display:ForAll("UpdateCooldownTextPosition")
	end

	rg.GetSelectedValue = function(self)
		return parent:GetGroupSets().anchor
	end

	self.anchorPicker = rg
	return rg
end

OmniCCOptions:AddTab("position", L.PositionSettings, PositionOptions)
