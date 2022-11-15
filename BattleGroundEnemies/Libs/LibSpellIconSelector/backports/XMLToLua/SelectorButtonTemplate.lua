
local AddonName, Data = ...


Data.Templates = Data.Templates or {}


Data.Templates.ApplyToButton = function(button)
	if not button.isFullyCreated then
		Mixin(button, Data.Mixins.BackportedSelectorButtonMixin)
		button:SetSize(36, 36)
		button.BackgroundTexture = button:CreateTexture(nil, "BACKGROUND")
		button.BackgroundTexture:SetSize(45, 45)
		button.BackgroundTexture:SetPoint("CENTER", 0, -1)
		button.BackgroundTexture:SetTexture("Interface\\Buttons\\UI-EmptySlot-Disabled")
		button.BackgroundTexture:SetTexCoord(0.140625, 0.84375, 0.140625, 0.84375)
	

		button.SelectedTexture = button:CreateTexture(nil, "OVERLAY")
		button.SelectedTexture:SetAllPoints()
		button.SelectedTexture:SetBlendMode("ADD")
		button.SelectedTexture:SetTexture("Interface\\Buttons\\CheckButtonHilight")
		button.SelectedTexture:Hide()
	

		button:SetScript("OnClick", button.OnClick)
		button.Icon = button:GetNormalTexture()
		if not button.Icon then
			button.Icon = button:SetNormalTexture(0)
			button.Icon = button:GetNormalTexture()
		end
	
		button.Icon:SetSize(36, 36)
		button.Icon:SetPoint("CENTER", 0, -1)
	
		button.Highlight = button:GetHighlightTexture()
		if not button.Highlight then
			button.Highlight = button:SetHighlightTexture(0)
			button.Highlight = button:GetHighlightTexture()
		end
		button.Highlight:SetAllPoints()
		button.Highlight:SetBlendMode("ADD")
		button.Highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
		button.isFullyCreated = true
	end

	return button
end



-- Data.Templates.SelectorButtonTemplate = function(parent)
-- 	local button =  CreateFrame("button", nil, parent)
-- 	button = Data.Templates.ApplyToButton(button)
-- 	return button
-- end

