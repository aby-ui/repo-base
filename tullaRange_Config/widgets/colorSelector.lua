--[[
	colorSelector.lua
		A bagnon color selector
--]]

local _, Addon = ...
local L = Addon.L
local tullaRange = _G.tullaRange
local ColorSelector = Addon.Classy:New('Frame'); Addon.ColorSelector = ColorSelector

local backdrop = {
  bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
  edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
  edgeSize = 16,
  tile = true, tileSize = 16,
  insets = {left = 4, right = 4, top = 4, bottom = 4}
}

local ColorSliders = { 'Red', 'Green', 'Blue' }


function ColorSelector:New(colorState, parent)
	local f = self:Bind(CreateFrame('Frame', parent:GetName() .. '_' .. colorState, parent))

	f:SetBackdrop(backdrop)
	f:SetBackdropBorderColor(0.4, 0.4, 0.4)
	f:SetBackdropColor(0, 0, 0, 0.3)

	local t = f:CreateFontString(nil, 'BACKGROUND', 'GameFontHighlightLarge')
	t:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 4, 2)
	t:SetText(L[colorState])
	f.text = t

	local preview = f:CreateTexture(nil, 'ARTWORK')
	preview:SetPoint('RIGHT', -16, 0)
	preview:SetSize(96, 96)
	f.preview = preview

	-- color sliders
	local sliders = {}
	for colorIndex, colorName in ipairs(ColorSliders) do
		local slider = Addon.Slider:New(L[colorName], f, 0, 100, 1)

		slider.SetSavedValue = function(_, value)
			tullaRange.sets[colorState][colorIndex] = math.floor(value + 0.5) / 100
			tullaRange:ForceColorUpdate()

			preview:SetVertexColor(tullaRange:GetColor(colorState))
		end

		slider.GetSavedValue = function()
			return tullaRange.sets[colorState][colorIndex] * 100
		end

		if colorIndex > 1 then
			slider:SetPoint('TOPLEFT', sliders[colorIndex - 1], 'BOTTOMLEFT', 0, -24)
		else
			slider:SetPoint('BOTTOMLEFT', t, 'BOTTOMLEFT', 8, -40)
		end

		table.insert(sliders, slider)
	end



	f.sliders = sliders

	return f
end

do
	local spellIcons = {}

	-- generate spell icons
	do
		for i = 1, GetNumSpellTabs() do
			local offset, numSpells = select(3, GetSpellTabInfo(i))
			local tabEnd = offset + numSpells

			for j = offset, tabEnd - 1 do
				local texture = GetSpellBookItemTexture(j, 'player')
				if texture then
					table.insert(spellIcons, texture)
				end
			end
		end
	end

	function ColorSelector:UpdateValues()

		local texture = spellIcons[math.random(1, #spellIcons)]

		self.preview:SetTexture(texture)

		for _, slider in pairs(self.sliders) do
			slider:UpdateValue()
		end
	end
end
