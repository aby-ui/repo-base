--[[
Copyright 2008-2018 João Cardoso
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

local Group = MakeSushi(6, nil, 'MagicGroup', nil, nil, SushiGroup)
if not Group then
	return
end


--[[ Constructor ]]--

function Group:OnCreate ()
	SushiGroup.OnCreate (self)
	self.Footer = self:CreateFontString(nil, nil, 'GameFontDisableSmall')
end

function Group:OnAcquire ()
	SushiGroup.OnAcquire (self)
	self:SetCall('UpdateChildren', self.CreateMagics)
	self.Footer:SetPoint('BOTTOMRIGHT', -4, 4)
	self:SetPoint('BOTTOMRIGHT', -4, 5)
	self:SetPoint('TOPLEFT', 4, -11)
	self:SetResizing('HORIZONTAL')
	self:SetSize(0, 0)
end


--[[ Addon ]]--

function Group:SetAddon (addon)
	self.name = addon
	self.prefix = addon .. '_'
	self.sets = _G[self.prefix .. 'Sets'] or _G[addon].Sets
	self.L = _G[self.prefix .. 'Locals'] or _G[addon].Locals
end

function Group:GetAddon ()
	return self.name
end

function Group:GetAddonInfo ()
	for i = 1, GetNumAddOns() do
		if GetAddOnInfo(i) ==  self.name then
			return GetAddOnInfo(i)
		end
	end
end


--[[ Footer ]]--

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
	self:CreateHeader(self.name, 'GameFontNormalLarge')
	self:CreateHeader(self.L['Description'] or select(3, self:GetAddonInfo()), 'GameFontHighlightSmall').bottom = 20
	self:FireCall('MagicChildren')
end


--[[ Create Child ]]--

function Group:CreateHeader(text, font, underline)
	local child = self:CreateChild('Header')
	child:SetText(self.L[text] or text)
	child:SetUnderlined(underline)
	child:SetWidth(591)
	child:SetFont(font)
	return child
end

function Group:Create(class, text, arg, disabled, small)
	local child = self:CreateChild(class)
	local arg = (self.sets and '' or self.prefix) .. (arg or text)
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
