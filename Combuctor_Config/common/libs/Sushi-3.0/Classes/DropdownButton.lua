local DropButton = MakeSushi(3, 'CheckButton', 'DropdownButton', nil, 'UIDropDownMenuButtonTemplate', SushiButtonBase)
if DropButton then
	DropButton.left = 16
	DropButton.top = 1
	DropButton.bottom = 1
else
	return
end


--[[ Startup ]]--

function DropButton:OnCreate()
	_G[self:GetName() .. 'UnCheck']:Hide()
	self.__super.OnCreate(self)
end

function DropButton:OnAcquire()
	self.isRadio = true
	self.__super.OnAcquire(self)
	self:SetCheckable(true)
	self:SetChecked(nil)
end

function DropButton:SetTitle(isTitle)
	local font = isTitle and GameFontNormalSmall or GameFontHighlightSmall
	self:SetNormalFontObject(font)
	self:SetHighlightFontObject(font)
end


--[[ Checked ]]--

function DropButton:SetChecked(checked)
	if checked then
		self:LockHighlight()
	else
		self:UnlockHighlight()
	end

	self.__type.SetChecked(self, checked)
	self:UpdateTexture()
end

function DropButton:SetCheckable(checkable)
	local name = self:GetName()
	_G[name .. 'Check']:SetShown(checkable)
	_G[name .. 'NormalText']:SetPoint('LEFT', checkable and 20 or 0, 0)
end

function DropButton:SetRadio(isRadio)
	self.isRadio = isRadio
	self:UpdateTexture()
end

function DropButton:UpdateTexture()
	local y = self.isRadio and 0.5 or 0
	local x = self:GetChecked() and 0 or 0.5

	_G[self:GetName() .. 'Check']:SetTexCoord(x, x+0.5, y, y+0.5)
end