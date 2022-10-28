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

local Clickable = LibStub('Sushi-3.1').Tipped:NewSushi('Clickable', 1)
if not Clickable then return end

function Clickable:Construct()
	local b = self:Super(Clickable):Construct()
	b:SetScript('OnClick', b.OnClick)
	return b
end

function Clickable:Reset()
	self:Super(Clickable):Reset()
	self:SetEnabled(true)
end

function Clickable:OnClick(button)
	local value = self.GetValue and self:GetValue()
	PlaySound(self.Sound)

	self:FireCalls('OnClick', button, value)
	self:FireCalls('OnInput', value)
	self:FireCalls('OnUpdate')
end

Clickable.Sound = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
