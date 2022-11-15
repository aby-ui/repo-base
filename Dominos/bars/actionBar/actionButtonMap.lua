--------------------------------------------------------------------------------
-- ActionButtonMap
-- Maps Blizzard action buttons to their default action IDs
--------------------------------------------------------------------------------

local _, Addon = ...

local BlizzardActionButtons = {}

if Addon:IsBuild("retail") then
    local function addBar(bar, page)
        if not (bar and bar.actionButtons) then return end

        page = page or bar:GetAttribute("actionpage")

        -- when assigning buttons, we skip bar 12 (totems)
        -- so shift pages above 12 down one
        if page > 12 then
            page = page - 1
        end

        local offset = (page - 1) * NUM_ACTIONBAR_BUTTONS

        for i, button in pairs(bar.actionButtons) do
            BlizzardActionButtons[i + offset] = button
        end
    end

    addBar(MainMenuBar, 1) -- 1
    addBar(MultiBarRight) -- 3
    addBar(MultiBarLeft) -- 4
    addBar(MultiBarBottomRight) -- 5
    addBar(MultiBarBottomLeft) -- 6
    addBar(MultiBar5) -- 13
    addBar(MultiBar6) -- 14
    addBar(MultiBar7) -- 15
else
    local function addButton(button, page)
        page = page or button:GetParent():GetAttribute("actionpage")

        local index = button:GetID() + (page - 1) * NUM_ACTIONBAR_BUTTONS

        BlizzardActionButtons[index] = button
    end

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        addButton(_G['ActionButton' .. i], 1) -- 1
        addButton(_G['MultiBarRightButton' .. i]) -- 3
        addButton(_G['MultiBarLeftButton' .. i]) -- 4
        addButton(_G['MultiBarBottomRightButton' .. i]) -- 5
        addButton(_G['MultiBarBottomLeftButton' .. i]) -- 6
    end
end

Addon.BlizzardActionButtons = BlizzardActionButtons
