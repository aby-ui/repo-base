local AddonName, Data = ...

Data.Mixins = Data.Mixins or {}

local BackportedSelectedIconButtonMixin = {};

function BackportedSelectedIconButtonMixin:SetIconTexture(iconTexture)
	self.Icon:SetTexture(iconTexture);
end

function BackportedSelectedIconButtonMixin:GetIconTexture()
	return self.Icon:GetTexture();
end

function BackportedSelectedIconButtonMixin:SetSelectedTexture()
	self.SelectedTexture:SetShown(self:GetIconSelectorPopupFrame():GetSelectedIndex() == nil);
end

function BackportedSelectedIconButtonMixin:OnClick()
	if ( self:GetIconSelectorPopupFrame():GetSelectedIndex() == nil ) then
		return;
	end

	self:GetIconSelectorPopupFrame().IconSelector:ScrollToSelectedIndex();
end

function BackportedSelectedIconButtonMixin:GetIconSelectorPopupFrame()
	return self.selectedIconButtonIconSelector;
end

function BackportedSelectedIconButtonMixin:SetIconSelector(iconSelector)
	self.selectedIconButtonIconSelector = iconSelector;
end

Data.Mixins.BackportedSelectedIconButtonMixin = BackportedSelectedIconButtonMixin