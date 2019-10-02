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

local Magic = SushiMagicGroup
local Credits = MakeSushi(2, nil, 'CreditsGroup', nil, nil, Magic)
if not Credits then
	return
end

local PATREON_LOGO = format('|T%s\\Art\\Patreon:13:13:0:0:64:64:10:54:10:54|t ', Sushi_Directory)
local FONTS = {
	'GameFontHighlightHuge',
	'GameFontHighlightLarge',
	'GameFontHighlight'
}

local PATRONS = 'Patrons'
local COPY_URL = 'Copy the following url into your browser'
local DESCRIPTION = '%s is distributed for free and supported trough donations. These are the people currently supporting development. Become a patron too at |cFFF96854%s|r.'

do
	local locale = GetLocale():sub(1, 2)
	if locale == 'cn' then
	elseif locale == 'de' then
		PATRONS = 'Schirmherren'
	elseif locale == 'es' then
	elseif locale == 'fr' then
	elseif locale == 'it' then
		PATRONS = 'Patronos'
	elseif locale == 'pt' then
		PATRONS = 'Patronos'
	elseif locale == 'ru' then
		PATRONS = 'покровители'
	elseif locale == 'tw' then
	end
end


--[[ Constructor ]]--

function Credits:OnAcquire ()
	Magic.OnAcquire(self)
	self:SetResizing('VERTICAL')
	self:SetOrientation('HORIZONTAL')
	self:SetChildren(self.CreatePeople)
  self.fonts, self.people, self.website = FONTS
end

function Credits:CreatePeople ()
  for i, type in ipairs(self.people or {}) do
		if type.people then
			self:CreateHeader(type.title, 'GameFontHighlight', true).top = i > 1 and 20 or 0

	    for j, name in ipairs(type.people) do
	    	self:CreateHeader(name, self.fonts[i]):SetWidth(180)
	    end
		end
  end
end

function Credits:CreateHeader (...)
	local header = Magic.CreateHeader(self, ...)
	header:SetHighlightFactor(1.5)
	header:SetCall('OnClick', function()
		SushiPopup:Display {
			text = COPY_URL,
			hasEditBox = 1, editBoxWidth = 260, editBoxText = self.website, autoHighlight = 1,
			whileDead = 1, exclusive = 1, hideOnEscape = 1,
			button1 = OKAY,
		}
	end)
	return header
end


--[[ API ]]--

function Credits:SetPeople (people)
  self.people = people
  self:Update()
end

function Credits:GetPeople ()
  return self.people
end

function Credits:SetFonts (fonts)
  self.fonts = fonts
  self:Update()
end

function Credits:GetFonts ()
  return self.fonts
end

function Credits:SetWebsite (website)
  self.website = website
end

function Credits:GetWebsite ()
  return self.website
end


--[[ Overrides ]]--

function Credits:GetTitle ()
	return self.title or (PATREON_LOGO .. PATRONS)
end

function Credits:GetSubtitle ()
	if self.subtitle then
		return self.subtitle
	end

	local website = self:GetWebsite() or ''
	website = website:match('^https?://(.+)$') or website
	website = website:match('^www\.(.+)$') or website

	return DESCRIPTION:format(self:GetAddon() or '', website)
end
