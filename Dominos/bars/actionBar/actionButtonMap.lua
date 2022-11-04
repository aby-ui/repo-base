--------------------------------------------------------------------------------
-- ActionButtonMap
-- Maps Blizzard action buttons to their default action IDs
--------------------------------------------------------------------------------

local _, Addon = ...

local ActionButtonMap = {}

if Addon:IsBuild("retail") then
    local function getActionPageOffset(bar)
        local page = bar:GetAttribute("actionpage")

        return (page - 1) * NUM_ACTIONBAR_BUTTONS
    end

    local function addBar(bar, offset)
        if not (bar and bar.actionButtons) then return end

        offset = offset or getActionPageOffset(bar)

        for i, button in pairs(bar.actionButtons) do
            ActionButtonMap[i + offset] = button
        end
    end

    addBar(MainMenuBar, 0)
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

        ActionButtonMap[index] = button
    end

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        addButton(_G['ActionButton' .. i], 1)
        addButton(_G['MultiBarRightButton' .. i])
        addButton(_G['MultiBarLeftButton' .. i])
        addButton(_G['MultiBarBottomRightButton' .. i])
        addButton(_G['MultiBarBottomLeftButton' .. i])
    end
end

Addon.ActionButtonMap = ActionButtonMap
