local AddonName, Data = ...

Data.Templates = Data.Templates or {}
Data.Templates.SelectionFrameTemplate = function(parent)
	local frame = CreateFrame("frame", nil, parent, "NineSlicePanelTemplate")
	-- frame.OnOkay = FooFrame_OnOkay
	-- frame.OnCancel = FooFrame_OnCancel
	frame.layoutType = "SelectionFrameTemplate"
	frame.CancelButton = CreateFrame("Button", nil, frame, "UIPanelButtonNoTooltipTemplate")
	frame.CancelButton:SetSize(78, 22)
	frame.CancelButton:SetPoint("BOTTOMRIGHT", -11, 13)
	frame.CancelButton:SetScript("OnClick", SelectionFrameCancelButton_OnClick)
	local text = frame.CancelButton.Text or frame.CancelButton.text
	text:SetText(CANCEL)

	frame.OkayButton = CreateFrame("Button", nil, frame, "UIPanelButtonNoTooltipTemplate")
	frame.OkayButton:SetSize(78, 22)
	frame.OkayButton:SetPoint("RIGHT", frame.CancelButton, "LEFT", -2, 0)
	frame.OkayButton:SetScript("OnClick", SelectionFrameOkayButton_OnClick)
	text = frame.OkayButton.Text or frame.OkayButton.text

	if frame.OnLoad then frame:OnLoad() end
	text:SetText(OKAY)
	return frame
end


