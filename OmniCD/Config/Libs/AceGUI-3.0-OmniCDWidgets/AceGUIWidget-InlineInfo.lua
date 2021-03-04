---------------------------------------------------------------------------------

-- Inline label with description field widget for AceGUI-3.0
-- Written as part of OmniCD by Treebonker

-- Parameters:
-- hidden = boolean,
-- name = "label",
-- type = "input",
-- get = function() return "field" end,

---------------------------------------------------------------------------------

--[[-----------------------------------------------------------------------------
EditBox Widget
-------------------------------------------------------------------------------]]
local Type, Version = "Info-OmniCD", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetHeight(18)
		self:SetFullWidth(true)
		self:SetDisabled(false)
		self:SetLabel()
		self:SetText()
	end,

	["SetDisabled"] = function(self, disabled) end,

	["SetText"] = function(self, text)
		self.field:SetText(text or "")
	end,

	["SetLabel"] = function(self, text)
		if text and text ~= "" then
			self.label:SetText(text)
			self.label:Show()
		else
			self.label:SetText("")
			self.label:Hide()
		end
		self:SetHeight(self.label:GetStringHeight() + 4) -- 2 for GameFontNormal
	end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall-OmniCD")
	label:SetPoint("TOPLEFT", 4, 0)
	label:SetPoint("BOTTOMLEFT", 4, 0)
	label:SetJustifyH("LEFT")
	label:SetWidth(100)

	local field = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall-OmniCD")
	field:SetPoint("TOPLEFT", label, "TOPRIGHT", 10, 0)
	field:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 0)
	field:SetJustifyH("LEFT")

	local widget = {
		field       = field,
		label       = label,
		frame       = frame,
		type        = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
