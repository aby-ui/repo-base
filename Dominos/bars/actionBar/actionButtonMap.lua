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

        local offset = (page - 1) * NUM_ACTIONBAR_BUTTONS

        for i, button in pairs(bar.actionButtons) do
            BlizzardActionButtons[i + offset] = button
        end
    end

    addBar(MainMenuBar, 1)
    addBar(MultiBarBottomLeft)
    addBar(MultiBarBottomRight)
    addBar(MultiBarLeft)
    addBar(MultiBarRight)
    addBar(MultiBar5)
    addBar(MultiBar6)
    addBar(MultiBar7)
else
    local function addButton(button, page)
        page = page or button:GetParent():GetAttribute("actionpage")

        local index = button:GetID() + (page - 1) * NUM_ACTIONBAR_BUTTONS

        BlizzardActionButtons[index] = button
    end

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        addButton(_G['ActionButton' .. i], 1)
        addButton(_G['MultiBarBottomLeftButton' .. i])
        addButton(_G['MultiBarBottomRightButton' .. i])
        addButton(_G['MultiBarLeftButton' .. i])
        addButton(_G['MultiBarRightButton' .. i])
    end
end

Addon.BlizzardActionButtons = BlizzardActionButtons
