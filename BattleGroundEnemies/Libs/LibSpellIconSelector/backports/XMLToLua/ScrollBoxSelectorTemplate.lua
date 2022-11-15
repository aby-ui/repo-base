local AddonName, Data = ...


Data.Templates = Data.Templates or {}
Data.Templates.ScrollBoxSelectorTemplate = function(parent)
	local frame = Data.Templates.SelectorTemplate(parent)
	Mixin(frame, Data.Mixins.BackportedScrollBoxSelectorMixin)

	frame:SetSize(494, 375)
	frame.ScrollBar = CreateFrame("EventFrame", nil, frame, "WowTrimScrollBar")
	frame.ScrollBar:SetPoint("TOPRIGHT")
	frame.ScrollBar:SetPoint("BOTTOMRIGHT")

	frame.ScrollBox = CreateFrame("frame", nil, frame, "WowScrollBoxList")
	frame.ScrollBox:SetPoint("TOP")
	frame.ScrollBox:SetPoint("BOTTOM")
	frame.ScrollBox:SetPoint("RIGHT", frame.ScrollBar, "LEFT")
	frame.ScrollBox:SetPoint("LEFT")

	frame:SetScript("OnShow", frame.OnShow)
	return frame
end

