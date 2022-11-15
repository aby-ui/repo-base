local _, Addon = ...
local ActionBarsModule = Addon:NewModule('ActionBars', 'AceEvent-3.0')

function ActionBarsModule:OnEnable()
    self.UpdateActionSlots = Addon:Defer(self.UpdateActionSlots, 0.1, self)
end

function ActionBarsModule:Load()
    self.slotsToUpdate = {}

    self:RegisterEvent('UPDATE_SHAPESHIFT_FORMS')
    self:RegisterEvent('UPDATE_BONUS_ACTIONBAR', 'OnOverrideBarUpdated')

    if OverrideActionBar then
        self:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR', 'OnOverrideBarUpdated')
        self:RegisterEvent('UPDATE_OVERRIDE_ACTIONBAR', 'OnOverrideBarUpdated')
    end

    self:SetBarCount(Addon:NumBars())
    Addon.RegisterCallback(self, "ACTIONBAR_COUNT_UPDATED")

    self:RegisterEvent("SPELLS_CHANGED")
    self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function ActionBarsModule:Unload()
    self:UnregisterAllEvents()
    self:ForActive('Free')
    self.active = nil
end

-- events
function ActionBarsModule:OnOverrideBarUpdated()
    if InCombatLockdown() or not (Addon.OverrideController and Addon.OverrideController:OverrideBarActive()) then
        return
    end

    local bar = Addon:GetOverrideBar()
    if bar then
        bar:ForButtons('Update')
    end
end

function ActionBarsModule:ACTIONBAR_COUNT_UPDATED(_, count)
    self:SetBarCount(count)
end

function ActionBarsModule:UPDATE_SHAPESHIFT_FORMS()
    if InCombatLockdown() then
        return
    end

    self:ForActive('UpdateStateDriver')
end

function ActionBarsModule:ACTIONBAR_SLOT_CHANGED(_event, slot)
    if not self.slotsToUpdate[slot] then
        self.slotsToUpdate[slot] = true
        self:UpdateActionSlots()
    end
end

function  ActionBarsModule:PLAYER_REGEN_ENABLED()
    if next(self.slotsToUpdate) then
        self:UpdateActionSlots()
    end
end

function ActionBarsModule:SPELLS_CHANGED()
    self:ForActive('ForButtons', 'UpdateShownInsecure')
end

function ActionBarsModule:SetBarCount(count)
    self:ForActive('Free')

    if count > 0 then
        self.active = {}

        for i = 1, count do
            self.active[i] = Addon.ActionBar:New(i)
        end
    else
        self.active = nil
    end
end

function ActionBarsModule:ForActive(method, ...)
    if self.active then
        for _, bar in pairs(self.active) do
            bar:CallMethod(method, ...)
        end
    end
end

function ActionBarsModule:UpdateActionSlots()
    if InCombatLockdown() then return end

    if not next(self.slotsToUpdate) then
        return
    end

    for _, bar in pairs(self.active) do
        for _, button in pairs(bar.buttons) do
            if self.slotsToUpdate[button:GetAttribute("action")] then
                button:UpdateShownInsecure()
            end
        end
    end

    table.wipe(self.slotsToUpdate)
end
