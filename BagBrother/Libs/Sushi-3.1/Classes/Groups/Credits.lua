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


local Sushi = LibStub('Sushi-3.1')
local Group = Sushi.OptionsGroup:NewSushi('CreditsGroup', 3, 'Frame')
if not Group then return end


--[[ Construct ]]--

function Group:New(parent, people, title)
	local f, p = self:Super(Group):New(parent, title or 'Patrons')
	f:SetCall('OnChildren', self.PopulatePeople)
	f:SetPeople(people)
	return f, p
end

function Group:PopulatePeople()
	if self.subtitle then
		local subtitle = self.Children[2]
		subtitle:SetHighlightFactor(1.5)
		subtitle:SetCall('OnClick', function()
			if self.url then
				Sushi.Popup {
					text = self.DialogMessage, button1 = OKAY, whileDead = 1, exclusive = 1, hideOnEscape = 1,
					hasEditBox = 1, editBoxWidth = 260, editBoxText = self.url, autoHighlight = 1
				}
			end
		end)
	end

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

function Group:SetSubtitle(subtitle, url)
	self.subtitle, self.url = subtitle, url
end

function Group:GetSubtitle()
	return self.subtitle, self.url
end


--[[ Proprieties ]]--

Group.orientation = 'HORIZONTAL'
Group.DialogMessage = 'Copy the following url into your browser'
Group.Fonts = {
	GameFontHighlightHuge,
	GameFontHighlightLarge,
	GameFontHighlight
}
