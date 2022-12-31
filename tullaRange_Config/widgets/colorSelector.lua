--[[
	colorSelector.lua
		A bagnon color selector
--]]
local _, Addon = ...
local L = Addon.L
local tullaRange = _G.tullaRange
local ColorSelector = Addon.Classy:New('Frame')
Addon.ColorSelector = ColorSelector

local ColorChannels = {'Red', 'Green', 'Blue', 'Opacity'}

function ColorSelector:New(state, parent)
    local result = self:Bind(CreateFrame('Frame', '$parentEditor_' .. state, parent))

    local heading = result:CreateFontString(nil, 'BACKGROUND', 'GameFontHighlightLarge')
    heading:SetJustifyH('LEFT')
    heading:SetPoint('TOPLEFT')
    heading:SetText(L[state])
    heading:SetWidth(120)
    result.text = heading

    local preview = result:CreateTexture(nil, 'ARTWORK')
    preview:SetPoint('LEFT')
    preview:SetSize(104, 104)
    result.preview = preview

    -- color sliders
    local sliders = {}
    for i, color in ipairs(ColorChannels) do
        local slider = Addon.Slider:New(L[color], result, 0, 100, 1)

        slider.SetSavedValue = function(_, value)
            tullaRange.sets[state][i] = math.floor(value + 0.5) / 100
            preview:SetVertexColor(tullaRange:GetColor(state))

            tullaRange:UpdateButtonStates()
        end

        slider.GetSavedValue = function()
            return tullaRange.sets[state][i] * 100
        end

        if i > 1 then
            slider:SetPoint('TOPLEFT', sliders[i - 1], 'BOTTOMLEFT', 0, -24)
            slider:SetPoint('RIGHT')
        else
            slider:SetPoint('TOPLEFT', heading, 'TOPRIGHT', 8, -16)
            slider:SetPoint('RIGHT')
        end

        sliders[i] = slider
    end

    result.sliders = sliders

    local desaturate = CreateFrame('CheckButton', '$parentDesaturate', result, 'InterfaceOptionsCheckButtonTemplate')
    desaturate.Text:SetText(L.Desaturate)

    desaturate:SetScript("OnShow", function(checkbox)
        local desaturated = tullaRange.sets[state].desaturate and true

        checkbox:SetChecked(desaturated)
        checkbox:GetParent().preview:SetDesaturated(desaturated)
    end)

    desaturate:SetScript("OnClick", function(checkbox)
        local desaturated = checkbox:GetChecked() and true

        checkbox:GetParent().preview:SetDesaturated(desaturated)
        tullaRange.sets[state].desaturate = desaturated

        tullaRange:UpdateButtonStates()
    end)

    desaturate:SetPoint('BOTTOMLEFT')

    return result
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
