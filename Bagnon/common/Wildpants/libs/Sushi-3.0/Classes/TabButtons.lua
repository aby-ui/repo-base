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

local Button = SushiButton
local CreateClass = LibStub('Poncho-1.0')
local Tab = MakeSushi(1, 'Button', 'TabButtonBase', nil, nil, Button)
if not Tab then
	return
end


--[[ General ]]--

function Tab:OnRelease()
	Button.OnRelease (self)
	self:SetSelected(nil)
end

function Tab:SetText (text)
	 self:GetFontString():SetText(text)
	 PanelTemplates_TabResize(self, 0)
end


--[[ State ]]--

function Tab:SetSelected (selected)
	self.selected = selected
	self:UpdateState()
end

function Tab:IsSelected()
	return self.selected
end

function Tab:SetDisabled (disabled)
	self.disabled = disabled
	self:UpdateState()
end

function Tab:IsDisabled ()
	return self.disabled
end

function Tab:UpdateState ()
	if self.disabled then
		PanelTemplates_SetDisabledTabState(self)
	elseif self.selected then
		PanelTemplates_SelectTab(self)
	else
		PanelTemplates_DeselectTab(self)
	end
end


--[[ Proprieties ]]--

Tab.sound = 'igCharacterInfoTab'
Tab.SetLabel = Tab.SetText
Tab.GetLabel = Tab.GetText
Tab.SetValue = Tab.SetSelected
Tab.GetValue = Tab.IsSelected
Tab.right = -7
Tab.left = -7


--[[ Styles ]]--

CreateClass('Button', 'SushiTooltipTab', nil, 'OptionsFrameTabButtonTemplate', Tab)
CreateClass('Button', 'SushiPanelTab', nil, 'CharacterFrameTabButtonTemplate', Tab)
CreateClass('Button', 'SushiDialogTab', nil, 'TabButtonTemplate', Tab).right = 9