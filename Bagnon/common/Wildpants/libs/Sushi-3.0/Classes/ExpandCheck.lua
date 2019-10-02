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
local Expand = MakeSushi(1, 'CheckButton', 'ExpandCheck', nil, nil, Check)
if not Expand then
	return
end

Expand.left = Check.left + 14


--[[ Events ]]--

function Expand:OnCreate()
	local toggle = CreateFrame('Button', nil, self)
	toggle:SetNormalTexture('Interface\\Buttons\\UI-PlusButton-UP')
	toggle:SetPushedTexture('Interface\\Buttons\\UI-PlusButton-DOWN')
	toggle:SetHighlightTexture('Interface\\Buttons\\UI-PlusButton-Hilight')
	toggle:SetScript('OnClick', function() self:OnExpandClick() end)
	toggle:SetPoint('LEFT', self, -14, 0)
	toggle:SetSize(14, 14)

	self.toggle = toggle
	Check.OnCreate(self)
end

function Expand:OnRelease()
	Check.OnRelease(self)
	self:SetExpanded(nil)
end

function Expand:OnExpandClick()
	local expanded = not self.expanded 
	self:SetExpanded(expanded)
	self:FireCall('OnToggle', expanded)
	self:FireCall('OnExpand', expanded)
	self:FireCall('OnUpdate')
end


--[[ Expansion ]]--

function Expand:SetExpanded(expanded)
	local texture = expanded and 'MINUS' or 'PLUS'
	self.toggle:SetNormalTexture('Interface\\Buttons\\UI-' .. texture ..  'Button-UP')
	self.toggle:SetPushedTexture('Interface\\Buttons\\UI-' .. texture .. 'Button-DOWN')
	self.expanded = expanded
end

function Expand:IsExpanded()
	return self.expanded
end
