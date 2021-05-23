--[[
	This code works around empty action buttons appearing on the multi action
	buttons either because the user has set to always show blizzard slots, or
	because the user has opened the spellbook

	We do this via clearing specific showgrid reasons on all the buttons on
	each MultiActionBar whenever the showgrid value changes
--]]
local _, Addon = ...

if not Addon:IsBuild('bcc', 'classic') then
    return
end

local MultiBarFixer = Addon:CreateHiddenFrame('Frame', nil, nil, 'SecureHandlerStateTemplate')

-- watch the primary action button for showgrid changes
-- this will work until we implement show empty buttons per bar
-- but has the side effect of working in combat
MultiBarFixer:WrapScript(ActionButton1, 'OnAttributeChanged', [[
    if name ~= "showgrid" then return end

    control:SetAttribute("showgrid", value or 0)
]])

MultiBarFixer:SetAttribute("showgrid", ActionButton1:GetAttribute("showgrid"))

-- ensure that the other action buttons maintain that state
for _, barName in pairs {'MultiBarBottomLeft', 'MultiBarBottomRight', 'MultiBarLeft', 'MultiBarRight'} do
    for i = 1, NUM_MULTIBAR_BUTTONS do
        local button = _G[('%sButton%d'):format(barName, i)]

        MultiBarFixer:WrapScript(button, 'OnAttributeChanged', [[
            if name ~= "showgrid" then return end

            local expected = control:GetAttribute("showgrid") or 0
            if value ~= expected then
                self:SetAttribute("showgrid", expected)
            end
        ]])

        button:SetAttribute("showgrid", ActionButton1:GetAttribute("showgrid"))
    end
end
