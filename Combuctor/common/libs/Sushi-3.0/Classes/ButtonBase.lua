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

local TipOwner = SushiTipOwner
local Button = MakeSushi(2, 'Button', 'ButtonBase', nil, nil, TipOwner)
if Button then
	Button.sound = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
else
	return
end


--[[ Events ]]--

function Button:OnCreate ()
	TipOwner.OnCreate(self)
	self:SetScript('OnClick', self.OnClick)
end

function Button:OnRelease ()
	TipOwner.OnRelease(self)
	self:SetDisabled(nil)
end

function Button:OnClick ()
	PlaySound(self.sound)
	self:FireCall('OnClick')
	self:FireCall('OnInput')
	self:FireCall('OnUpdate')
end


--[[ API ]]--

function Button:SetDisabled (disabled)
	if not disabled then
		self:Enable()
	else
		self:Disable()
	end
end
