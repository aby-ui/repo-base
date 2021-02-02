local _, Addon = ...

local ActionBarsModule = Addon:NewModule('ActionBars', 'AceEvent-3.0')

function ActionBarsModule:Load()
    self:RegisterEvent('UPDATE_SHAPESHIFT_FORMS')
    self:RegisterEvent('UPDATE_BONUS_ACTIONBAR', 'OnOverrideBarUpdated')

    if _G.OverrideActionBar then
        self:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR', 'OnOverrideBarUpdated')
        self:RegisterEvent('UPDATE_OVERRIDE_ACTIONBAR', 'OnOverrideBarUpdated')
    end

    self:RegisterEvent('PET_BAR_HIDEGRID')

    self:SetBarCount(Addon:NumBars())
    Addon.RegisterCallback(self, "ACTIONBAR_COUNT_UPDATED")
end

function ActionBarsModule:Unload()
    self:UnregisterAllEvents()
    self:ForAll('Free')
    self.active = nil
end

-- events
function ActionBarsModule:OnOverrideBarUpdated()
    if InCombatLockdown() or (not Addon.OverrideController:OverrideBarActive()) then
        return
    end

    local bar = Addon:GetOverrideBar()
    if bar then
        bar:ForButtons('Update')
    end
end

function ActionBarsModule:ACTIONBAR_COUNT_UPDATED(event, count)
    self:SetBarCount(count)
end

-- workaround for empty buttons not hiding when dropping a pet action
function ActionBarsModule:PET_BAR_HIDEGRID()
    if InCombatLockdown() then
        return
    end

    self:ForAll('HideGrid', ACTION_BUTTON_SHOW_GRID_REASON_EVENT or 2)
end

function ActionBarsModule:UPDATE_SHAPESHIFT_FORMS()
    if InCombatLockdown() then
        return
    end

    self:ForAll('UpdateStateDriver')
end

function ActionBarsModule:SetBarCount(count)
    self:ForAll('Free')

    if count > 0 then
        self.active = {}

        for i = 1, count do
            self.active[i] = Addon.ActionBar:New(i)
        end
    else
        self.active = nil
    end
end

function ActionBarsModule:ForAll(method, ...)
    if self.active then
        for _, bar in pairs(self.active) do
            bar:CallMethod(method, ...)
        end
    end
end