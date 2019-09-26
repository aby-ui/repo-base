--[[
	optionsPanel.lua
		A bagnon options panel
--]]

local _, Addon = ...
local OptionsPanel = Addon.Classy:New('Frame')

function OptionsPanel:New(name, parent, title, subtitle, icon)
	local f = self:Bind(CreateFrame('Frame', name))
	f.name = title
	f.parent = parent

	local text = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	text:SetPoint('TOPLEFT', 16, -16)
	if icon then
		text:SetFormattedText('|T%s:%d|t %s', icon, 32, title)
	else
		text:SetText(title)
	end

	local subtext = f:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	subtext:SetHeight(32)
	subtext:SetPoint('TOPLEFT', text, 'BOTTOMLEFT', 0, -8)
	subtext:SetPoint('RIGHT', f, -32, 0)
	subtext:SetNonSpaceWrap(true)
	subtext:SetJustifyH('LEFT')
	subtext:SetJustifyV('TOP')
	subtext:SetText(subtitle)

	InterfaceOptions_AddCategory(f)

	return f
end

Addon.OptionsPanel = OptionsPanel