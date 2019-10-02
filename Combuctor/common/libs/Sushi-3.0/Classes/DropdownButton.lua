--[[
Copyright 2008-2019 João Cardoso
Sushi is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Sushi.

Sushi is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Sushi is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Sushi. If not, see <http://www.gnu.org/licenses/>.
--]]

local DropButton = MakeSushi(4, 'CheckButton', 'DropdownButton', nil, 'UIDropDownMenuButtonTemplate', SushiButtonBase)
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
	self:EnableMouse(not isTitle)
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
