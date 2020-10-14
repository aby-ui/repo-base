--[[
	This code works around empty action buttons appearing on the multi action
	buttons either because the user has set to always show blizzard slots, or
	because the user has opened the spellbook

	We do this via clearing specific showgrid reasons on all the buttons on
	each MultiActionBar whenever the showgrid value changes
--]]
local _, Addon = ...

if not Addon:IsBuild('retail') then
    return
end

local MultiBarFixer = Addon:CreateHiddenFrame('Frame', nil, nil, 'SecureHandlerBaseTemplate')

-- adapted from http://lua-users.org/wiki/BitUtils
MultiBarFixer:SetAttribute('ClearFlags', [[
    local set = ...

    for i = 2, select("#", ...) do
        local flag = select(i, ...)

        if set % (2 * flag) >= flag then
            set = set - flag
        end
    end

    return set
]])

-- clears the given show grid reasons
local OnAttributeChanged = ([[
    if name == "showgrid" and value > 0 then
        value = control:RunAttribute("ClearFlags", value, %d, %d)

        if self:GetAttribute("showgrid") ~= value then
            self:SetAttribute("showgrid", value)
        end
    end
]]):format(ACTION_BUTTON_SHOW_GRID_REASON_CVAR, ACTION_BUTTON_SHOW_GRID_REASON_SPELLBOOK)

-- apply to every multi bar action button
for _, barName in pairs {'MultiBarBottomLeft', 'MultiBarBottomRight', 'MultiBarLeft', 'MultiBarRight'} do
    for i = 1, NUM_MULTIBAR_BUTTONS do
        local buttonName = ('%sButton%d'):format(barName, i)
        local button = _G[buttonName]

        MultiBarFixer:WrapScript(button, 'OnAttributeChanged', OnAttributeChanged)
    end
end
