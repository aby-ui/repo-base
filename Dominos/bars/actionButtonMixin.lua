--------------------------------------------------------------------------------
-- ActionButtonMixin
-- Additional methods we define on action buttons
--------------------------------------------------------------------------------
local _, Addon = ...
local ActionButtonMixin = {}

function ActionButtonMixin:SetActionOffsetInsecure(offset)
    if InCombatLockdown() then
        return
    end

    local oldActionId = self:GetAttribute('action')
    local newActionId = self:GetAttribute('index') + (offset or 0)

    if oldActionId ~= newActionId then
        self:SetAttribute('action', newActionId)
        self:UpdateState()
    end
end

function ActionButtonMixin:ShowGridInsecure(reason)
    if InCombatLockdown() then
        return
    end

    local oldShowGrid = self:GetAttribute('showgrid') or 0
    local newShowGrid = bit.bor(oldShowGrid, reason)

    if oldShowGrid ~= newShowGrid then
        self:SetAttribute('showgrid', newShowGrid)
        self:ShowGrid(reason)
    end
end

function ActionButtonMixin:HideGridInsecure(reason)
    if InCombatLockdown() then
        return
    end

    local oldShowGrid = self:GetAttribute('showgrid') or 0

    if oldShowGrid > 0 then
        local newShowGrid = bit.band(oldShowGrid, bit.bnot(reason))
        self:SetAttribute('showgrid', newShowGrid)
        self:HideGrid(reason)
    end
end

-- configuration commands
function ActionButtonMixin:SetFlyoutDirection(direction)
    if InCombatLockdown() then
        return
    end

    self:SetAttribute("flyoutDirection", direction)
    ActionButton_UpdateFlyout(self)
end

function ActionButtonMixin:SetShowCountText(show)
    if show then
        self.Count:Show()
    else
        self.Count:Hide()
    end
end

function ActionButtonMixin:SetShowMacroText(show)
    if show then
        self.Name:Show()
    else
        self.Name:Hide()
    end
end

function ActionButtonMixin:SetShowEquippedItemBorders(show)
    if show then
        self.Border:SetParent(self)
    else
        self.Border:SetParent(Addon.ShadowUIParent)
    end
end

-- we hide cooldowns when action buttons are transparent
-- so that the sparks don't appear
function ActionButtonMixin:SetShowCooldowns(show)
    if show then
        if self.cooldown:GetParent() ~= self then
            self.cooldown:SetParent(self)
            ActionButton_UpdateCooldown(self)
        end
    else
        self.cooldown:SetParent(Addon.ShadowUIParent)
    end
end

-- in classic, blizzard action buttons don't use a mixin
-- so define some methods that we'd expect
if Addon:IsBuild('bcc', 'classic') then
    ActionButtonMixin.HideGrid = ActionButton_HideGrid
    ActionButtonMixin.ShowGrid = ActionButton_ShowGrid
    ActionButtonMixin.UpdateState = ActionButton_UpdateState
    ActionButtonMixin.Update = ActionButton_Update

    hooksecurefunc("ActionButton_UpdateHotkeys", Addon.BindableButton.UpdateHotkeys)
end

Addon.ActionButtonMixin = ActionButtonMixin
