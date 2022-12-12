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

local Group = LibStub('Sushi-3.1').Group:NewSushi('OptionsGroup', 2, 'Frame')
if not Group then return end


--[[ Construct ]]--

function Group:Construct()
	local g = self:Super(Group):Construct()
	g.Footer = g:CreateFontString(nil, nil, 'GameFontDisableSmall')
	g.Footer:SetPoint('BOTTOMRIGHT', -4, 4)
	return g
end

function Group:New(category, subcategory)
	assert(category, 'First parameter to `OptionsGroup:New` is not optional')

	local dock = CreateFrame('Frame', nil, InterfaceOptionsFrame or SettingsPanel)
	if subcategory then
		dock.parent, dock.name = type(category) == 'table' and category.name or category, subcategory
	else
		dock.name = category
	end

	local group = self:Super(Group):New(dock)
	group.name, group.title = dock.name, dock.name
	group.category = InterfaceOptions_AddCategory(dock)
	group:SetPoint('BOTTOMRIGHT', -4, 5)
	group:SetPoint('TOPLEFT', 4, -11)
	group:SetFooter(nil)
	group:SetSize(0, 0)
	group:SetCall('OnChildren', function(self)
		if self:GetTitle() then
			self:Add('Header', self:GetTitle(), GameFontNormalLarge)
		end

		if self:GetSubtitle() then
			self:Add('Header', self:GetSubtitle(), GameFontHighlightSmall).bottom = 20
		end
	end)

	dock.default = function() group:FireCalls('OnDefaults')	end
	dock.cancel = function() group:FireCalls('OnCancel') end
	dock.okay = function() group:FireCalls('OnOkay') end
	dock:Hide()

	return group
end


--[[ API ]]--

function Group:Open()
	if InterfaceOptionsFrame then
		InterfaceOptionsFrame:Show()
		InterfaceOptionsFrame_OpenToCategory(self:GetParent())
	else
		SettingsPanel:Show()
		SettingsPanel:SelectCategory(self.category) -- GetCategory is bugged, must go direct
	end
end

function Group:SetTitle(title)
	self.title = title
end

function Group:GetTitle()
	return self.title
end

function Group:SetSubtitle(subtitle)
	self.subtitle = subtitle
end

function Group:GetSubtitle()
	return self.subtitle
end

function Group:SetFooter(footer)
	self.Footer:SetText(footer)
end

function Group:GetFooter()
	return self.Footer:GetText()
end
