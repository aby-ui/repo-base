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

local Base = SushiButtonBase
local Check = MakeSushi(3, 'CheckButton', 'CheckButton', nil, 'InterfaceOptionsCheckButtonTemplate', Base)
if not Check then
	return
end

SushiCheck = Check
Check.SetValue = Check.SetChecked
Check.GetValue = Check.GetChecked
Check.SetLabel = Check.SetText
Check.GetLabel = Check.GetText
Check.right = 134
Check.bottom = 8
Check.left = 10


--[[ Events ]]--

function Check:OnCreate ()
	Base.OnCreate(self)
	self:SetFontString(_G[self:GetName()..'Text'])
end

function Check:OnRelease ()
	Base.OnRelease(self)
	self:SetChecked(nil)
	self:SetSmall(false)
end

function Check:OnClick ()
	local checked = self:GetChecked()
	if checked then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end

	self:FireCall('OnClick', checked)
	self:FireCall('OnInput', checked)
	self:FireCall('OnUpdate')
end


--[[ Text ]]--

function Check:SetSmall (small)
	if small then
		self:SetDisabledFontObject('GameFontDisableSmall')
		self:SetNormalFontObject('GameFontHighlightSmall')
	else
		self:SetDisabledFontObject('GameFontDisable')
		self:SetNormalFontObject('GameFontHighlight')
	end
end

function Check:IsSmall ()
	return self:GetNormalFontObject() == 'GameFontHighlightSmall'
end
