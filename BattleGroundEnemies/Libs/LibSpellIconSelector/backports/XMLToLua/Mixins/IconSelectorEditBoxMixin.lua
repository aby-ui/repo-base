local AddonName, Data = ...

Data.Mixins = Data.Mixins or {}

local IconSelectorEditBoxMixin = {};

function IconSelectorEditBoxMixin:OnTextChanged()
	local iconSelectorPopupFrame = self:GetIconSelectorPopupFrame();
	local text = self:GetText();
	text = string.gsub(text, "\"", "");
	if #text > 0 then
		iconSelectorPopupFrame.BorderBox.OkayButton:Enable();
	else
		iconSelectorPopupFrame.BorderBox.OkayButton:Disable();
	end
end

function IconSelectorEditBoxMixin:OnEnterPressed()
	local text = self:GetText();
	text = string.gsub(text, "\"", "");
	if #text > 0 then
		self:GetIconSelectorPopupFrame():OkayButton_OnClick();
	end
end

function IconSelectorEditBoxMixin:OnEscapePressed()
	self:GetIconSelectorPopupFrame():CancelButton_OnClick();
end

function IconSelectorEditBoxMixin:GetIconSelectorPopupFrame()
	return self.editBoxIconSelector;
end

function IconSelectorEditBoxMixin:SetIconSelector(iconSelector)
	self.editBoxIconSelector = iconSelector;
end

Data.Mixins.BackportedIconSelectorEditBoxMixin = IconSelectorEditBoxMixin