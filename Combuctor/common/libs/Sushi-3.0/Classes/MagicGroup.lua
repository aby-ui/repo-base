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

local Group = MakeSushi(9, nil, 'MagicGroup', nil, nil, SushiGroup)
if not Group then
	return
end


--[[ Constructors ]]--

function Group:CreateOptionsCategory (parent, title)
	local category = CreateFrame('Frame')
	local group = self(category)
	group.Category = category
	group:SetTitle(title)

	category:Hide()
	category.parent = parent
	category.name = group:GetTitle()
	InterfaceOptions_AddCategory(category)

	return group
end

function Group:OnCreate ()
	SushiGroup.OnCreate (self)
	self.Footer = self:CreateFontString(nil, nil, 'GameFontDisableSmall')
	self.Footer:SetPoint('BOTTOMRIGHT', -4, 4)
end

function Group:OnAcquire ()
	SushiGroup.OnAcquire (self)
	self:SetCall('UpdateChildren', self.CreateMagics)
	self:SetPoint('BOTTOMRIGHT', -4, 5)
	self:SetPoint('TOPLEFT', 4, -11)
	self:SetResizing('HORIZONTAL')
	self:SetSize(0, 0)
	self:SetAddon(nil)
end


--[[ Addon ]]--

function Group:SetAddon (addon)
	self.addon = addon
	self.prefix = addon and (addon .. '_')
	self.sets = addon and (_G[self.prefix .. 'Sets'] or _G[addon].Sets)
	self.L = addon and (_G[self.prefix .. 'Locals'] or _G[addon].Locals) or {}
end

function Group:GetAddon ()
	return self.addon
end

function Group:GetAddonInfo ()
	local addon = self:GetAddon()
	for i = 1, GetNumAddOns() do
		if GetAddOnInfo(i) == addon then
			return GetAddOnInfo(i)
		end
	end
end


--[[ Text Fields ]]--

function Group:SetTitle (title)
	self.title = title
end

function Group:GetTitle ()
	return self.title or self:GetAddon()
end

function Group:SetSubtitle (subtitle)
	self.subtitle = subtitle
end

function Group:GetSubtitle ()
	return self.subtitle or self.L['Description'] or select(3, self:GetAddonInfo())
end

function Group:SetFooter (footer)
	self.Footer:SetText(footer)
end

function Group:GetFooter ()
	return self.Footer:GetText()
end


--[[ Manage Children ]]--

function Group:SetChildren (...)
	self:SetCall('MagicChildren', ...)
	self:UpdateChildren()
end

function Group:CreateMagics()
	local title = self:GetTitle()
	if title then
		self:CreateHeader(title, 'GameFontNormalLarge')
	end

	local subtitle = self:GetSubtitle()
	if subtitle then
		self:CreateHeader(subtitle, 'GameFontHighlightSmall').bottom = 20
	end

	self:FireCall('MagicChildren')
end

function Group:CreateHeader(text, font, underline)
	local child = self:CreateChild('Header')
	child:SetText(self.L[text] or text)
	child:SetUnderlined(underline)
	child:SetWidth(585)
	child:SetFont(font)
	return child
end

function Group:Create(class, text, arg, disabled, small)
	local child = self:CreateChild(class)
	local arg = (self.sets and '' or self.prefix or '') .. (arg or text)
	local sets = self.sets or _G
	local L = self.L

	child:SetTip(L[text .. 'Tip'], L[text .. 'TipText'])
	child:SetLabel(L[text] or text)
	child:SetDisabled(disabled)
	child:SetValue(sets[arg])
	child:SetSmall(small)

	child.left = (child.left or 0) + (small and 10 or 0)
	child:SetCall('OnInput', function(self, v)
		sets[arg] = v
	end)
	return child
end

Group.SetContent = Group.SetChildren
