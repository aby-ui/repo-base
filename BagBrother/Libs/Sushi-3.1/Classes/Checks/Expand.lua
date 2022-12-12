--[[
Copyright 2008-2022 João Cardoso
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

local Expand = LibStub('Sushi-3.1').Check:NewSushi('ExpandCheck', 2, 'CheckButton')
if not Expand then return end


--[[ API ]]--

function Expand:Construct()
	local b = self:Super(Expand):Construct()
	local toggle = CreateFrame('Button', nil, b)
	toggle:SetHighlightTexture('Interface/Buttons/UI-PlusButton-Hilight')
	toggle:SetScript('OnClick', function() b:OnExpandClick() end)
	toggle:SetPoint('LEFT', -14, 0)
	toggle:SetSize(14, 14)

	b.Toggle = toggle
	return b
end

function Expand:New(...)
	local b = self:Super(Expand):New(...)
	b:SetExpanded(true, nil)
	return b
end

function Expand:SetExpanded(can, is)
	local texture = is and 'MINUS' or 'PLUS'
	self.Toggle:SetNormalTexture('Interface/Buttons/UI-' .. texture ..  'Button-Up')
	self.Toggle:SetPushedTexture('Interface/Buttons/UI-' .. texture .. 'Button-Down')
	self.Toggle:GetNormalTexture():SetDesaturated(not can)
	self.Toggle:SetEnabled(can)
end

function Expand:IsExpanded()
	return self.Toggle:IsEnabled(),
				 self.Toggle:GetNormalTexture():GetTexture() == GetFileIDFromPath('Interface/Buttons/UI-MinusButton-Up')
end

function Expand:OnExpandClick()
	local can, is = self:IsExpanded()

	PlaySound(self.Sound)
	self:SetExpanded(can, not is)
	self:FireCalls('OnExpand', not is)
	self:FireCalls('OnUpdate')
end


--[[ Proprieties ]]--

Expand.left = Expand:GetSuper().left + 14
