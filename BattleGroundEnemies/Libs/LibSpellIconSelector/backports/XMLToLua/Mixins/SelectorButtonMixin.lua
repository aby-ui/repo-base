local AddonName, Data = ...

Data.Mixins = Data.Mixins or {}


local SelectorButtonMixin = {};



function SelectorButtonMixin:Init(selectorFrame)
	self.selectorFrame = selectorFrame;
end

function SelectorButtonMixin:SetSelectionIndex(selectionIndex)
	self.selectionIndex = selectionIndex;
	self:UpdateSelectedTexture();
end

function SelectorButtonMixin:GetSelectionIndex()
	return self.selectionIndex;
end

function SelectorButtonMixin:SetIconTexture(iconTexture)
	self.Icon:SetTexture(iconTexture);
end

function SelectorButtonMixin:GetIconTexture()
	return self.Icon:GetTexture();
end

function SelectorButtonMixin:UpdateSelectedTexture()
	self.SelectedTexture:SetShown(self:GetSelectorFrame():IsSelected(self.selectionIndex));
end

function SelectorButtonMixin:OnClick()
	self:GetSelectorFrame():OnSelection(self.selectionIndex);
end

function SelectorButtonMixin:GetSelection()
	return self:GetSelectorFrame():GetSelection(self.selectionIndex);
end

function SelectorButtonMixin:GetSelectorFrame()
	return self.selectorFrame;
end

Data.Mixins.BackportedSelectorButtonMixin = SelectorButtonMixin