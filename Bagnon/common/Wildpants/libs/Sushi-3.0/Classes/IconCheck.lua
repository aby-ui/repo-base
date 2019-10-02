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

local Check = SushiCheck
local Icon = MakeSushi(1, 'CheckButton', 'IconCheck', nil, nil, Check)
if not Icon then
	return
end


--[[ Builder ]]--

function Icon:OnCreate()
	Check.OnCreate (self)
	
	self:SetHighlightTexture(nil)
	self:SetSize(30, 30)
end

function Icon:OnAcquire()
	Check.OnAcquire (self)
	
	self.check = Check(self)
	self.check:SetPoint('BOTTOMRIGHT', 15, -15)
	self.check:SetCall('OnInput', function(check, ...)
		self:FireCall('OnClick', ...)
		self:FireCall('OnInput', ...)
		self:FireCall('OnUpdate', ...)
	end)
end

function Icon:OnRelease()
	Check.OnRelease (self)
	self.check:Release()
	self:SetIcon(nil)
end


--[[ Hacky API ]]--

do
	local methods = {
		'SetChecked',
		'GetChecked',
		'SetText',
		'GetText',
		'SetTip',
		'GetTip',
		'SetDisabled',
		'IsDisabled',
		'SetSmall',
		'IsSmall'
	}

	for i, method in ipairs(methods) do
		Icon[method] = function(self, ...)
			return self.check[method](self.check, ...)
		end
	end
end

function Icon:GetIcon()
	return self:GetNormalTexture():GetTexture()
end


--[[ Proprieties ]]--

Icon.SetIcon = Icon.SetNormalTexture
Icon.SetValue = Icon.SetChecked
Icon.GetValue = Icon.GetChecked
Icon.SetLabel = Icon.SetText
Icon.GetLabel = Icon.GetText
Icon.bottom = 18
Icon.right = 10
Icon.left = 10
Icon.top = 2