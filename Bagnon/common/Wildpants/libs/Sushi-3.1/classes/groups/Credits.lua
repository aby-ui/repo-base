--[[
Copyright 2018 João Cardoso
Patronize is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Patronize.

Patronize is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Patronize is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Patronize. If not, see <http://www.gnu.org/licenses/>.
--]]

local Sushi = LibStub('Sushi-3.1')
local Group = Sushi.OptionsGroup:NewSushi('CreditsGroup', 1, 'Frame')
if not Group then return end


--[[ Construct ]]--

function Group:New(parent, people, title)
	local f, p = self:Super(Group):New(parent, title or self.title)
	f:SetCall('OnChildren', self.PopulatePeople)
	f:SetPeople(people)
	return f, p
end

function Group:PopulatePeople()
	local subtitle = self.Children[2]
	subtitle:SetHighlightFactor(1.5)
	subtitle:SetCall('OnClick', function()
		if self.external then
			Sushi.Popup {
				text = self.DialogMessage, button1 = OKAY, whileDead = 1, exclusive = 1, hideOnEscape = 1,
				hasEditBox = 1, editBoxWidth = 260, editBoxText = self.external, autoHighlight = 1
			}
		end
	end)

	for i, section in ipairs(self:GetPeople()) do
		if section.people then
			self:Add('Header', section.title, GameFontHighlight, true).top = i > 1 and 20 or 0

			for j, name in ipairs(section.people) do
				self:Add('Header', name, section.font or self.Fonts[i]):SetWidth(180)
			end
		end
	end
end


--[[ API ]]--

function Group:SetPeople(people)
  self.people = people
end

function Group:GetPeople()
  return self.people or {}
end

function Group:SetSubtitle(subtitle, external)
	self.subtitle, self.external = subtitle, external
end

function Group:GetSubtitle()
	local external = self.external or ''
	external = external:match('^https?://(.-)/?$') or external
	external = external:match('^www\.(.-)$') or external

	return self.subtitle:gsub('%%p', self:GetProduct() or ''):gsub('%%e', external)
end

function Group:GetProduct()
	local panel = self:GetParent()
	return panel and panel.parent and panel.parent:gsub(' *|T.-|t *', '')
end


--[[ Proprieties ]]--

do
	local locale = GetLocale():sub(1, 2)
	if locale == 'de' then
		Group.title = 'Schirmherren'
	elseif locale == 'es' then
		Group.title = 'Patronos'
	elseif locale == 'it' then
		Group.title = 'Patronos'
	elseif locale == 'pt' then
		Group.title = 'Patronos'
	elseif locale == 'ru' then
		Group.title = 'покровители'
	else
		Group.title = 'Patrons'
	end
end

Group.orientation = 'HORIZONTAL'
Group.title = Group.title .. format(' |T%s/art/Patreon:13:13:0:0:64:64:10:54:10:54|t', Sushi.InstallLocation)
Group.subtitle = '%p is distributed for free and supported trough donations. These are the people currently supporting development. Become a patron too at |cFFF96854%e|r.'

Group.DialogMessage = 'Copy the following url into your browser'
Group.Fonts = {
	GameFontHighlightHuge,
	GameFontHighlightLarge,
	GameFontHighlight
}
