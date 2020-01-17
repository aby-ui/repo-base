--[[
Copyright 2008-2020 João Cardoso
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

local Group = LibStub('Sushi-3.1').Group:NewSushi('OptionsGroup', 1, 'Frame')
if not Group then return end

local function NewCategory(parent, name)
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	f.parent, f.name = parent and parent.name, name
	f:Hide()

	InterfaceOptions_AddCategory(f)
	return f
end


--[[ Construct ]]--

function Group:Construct()
	local f = self:Super(Group):Construct()
	f.Footer = f:CreateFontString(nil, nil, 'GameFontDisableSmall')
	f.Footer:SetPoint('BOTTOMRIGHT', -4, 4)
	return f
end

function Group:New(category, subcategory)
	assert(category, 'First parameter to `OptionsGroup:New` is not optional')
	if type(category) == 'string' then
		category = NewCategory(nil, category)
	elseif subcategory then
		category = NewCategory(category, subcategory)
	end

	local f = self:Super(Group):New(category)
	f.name = category.name
	f:SetPoint('BOTTOMRIGHT', -4, 5)
	f:SetPoint('TOPLEFT', 4, -11)
	f:SetFooter(nil)
	f:SetSize(0, 0)
	f:SetCall('OnChildren', function(self)
		if self:GetTitle() then
			self:Add('Header', self:GetTitle(), GameFontNormalLarge)
		end

		if self:GetSubtitle() then
			self:Add('Header', self:GetSubtitle(), GameFontHighlightSmall).bottom = 20
		end
	end)

	category.default = function() f:FireCalls('OnDefaults')	end
	category.cancel = function() f:FireCalls('OnCancel') end
	category.okay = function() f:FireCalls('OnOkay') end

	return f, category
end


--[[ API ]]--

function Group:Open()
	InterfaceOptionsFrame:Show()
	InterfaceOptionsFrame_OpenToCategory(self:GetParent())
end

function Group:SetTitle(title)
	self.name = title
end

function Group:GetTitle()
	return self.name
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
