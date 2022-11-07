if not PetActionBar then return end

--------------------------------------------------------------------------------
-- Pet Bar
-- A movable action bar for pets
--------------------------------------------------------------------------------

local AddonName, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

--------------------------------------------------------------------------------
-- Pet Buttons
--
-- In retail, we can't use the existing pet action slots, and there isn't really
-- a sufficient amount of secure environment actions to perfectly reimplement
-- the pet bar.
--
-- To work around this, we implement our own pet bar, but keep the other one
-- still active (but invisible). This lets us use the old bar to track when our
-- bar should be shown
--------------------------------------------------------------------------------

local PetActionButtonMixin = {}

function PetActionButtonMixin:CancelSpellDataLoadedCallback()
    local cancelFunc = self.spellDataLoadedCancelFunc

    if cancelFunc then
		cancelFunc()
		self.spellDataLoadedCancelFunc = nil
	end
end

-- this is mostly a straight port of PetActionBarMixin:Update()
function PetActionButtonMixin:Update()
    local petActionID = self:GetID()
    local petActionIcon = self.icon
    local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(petActionID)

    self.isToken = isToken

    self.tooltipName = isToken and name or _G[name]

    if spellID and spellID ~= self.spellID then
        self.spellID = spellID

        local spell = Spell:CreateFromSpellID(spellID)

        self.spellDataLoadedCancelFunc = spell:ContinueWithCancelOnSpellLoad(function()
            self.tooltipSubtext = spell:GetSpellSubtext()
        end)
    end

    if isActive then
        if IsPetAttackAction(petActionID) then
            self:StartFlash()
            self:GetCheckedTexture():SetAlpha(0.5)
        else
            self:StopFlash()
            self:GetCheckedTexture():SetAlpha(1)
        end
    else
        self:StopFlash()
    end

    self:SetChecked(isActive and true)

    self.AutoCastable:SetShown(autoCastAllowed and true)

    if autoCastEnabled then
        AutoCastShine_AutoCastStart(self.AutoCastShine)
    else
        AutoCastShine_AutoCastStop(self.AutoCastShine)
    end

    if texture then
        if GetPetActionSlotUsable(petActionID) then
            petActionIcon:SetVertexColor(1, 1, 1)
        else
            petActionIcon:SetVertexColor(0.4, 0.4, 0.4)
        end

        petActionIcon:SetTexture(isToken and _G[texture] or texture)
        petActionIcon:Show()
    else
        petActionIcon:Hide()
    end

    SharedActionButton_RefreshSpellHighlight(self, PET_ACTION_HIGHLIGHT_MARKS[petActionID])
end

function PetActionButtonMixin:UpdateCooldown()
    local cooldown = self.cooldown
    local start, duration, enable = GetPetActionCooldown(self:GetID())

    if enable and enable ~= 0 and start > 0 and duration > 0 then
        cooldown:SetCooldown(start, duration)
    else
        cooldown:Clear()
    end

    if GameTooltip and GameTooltip:IsOwned(self) then
        self:OnEnter()
    end
end

function PetActionButtonMixin:UpdateShownInsecure()
    if InCombatLockdown() then
        return
    end

    self:SetShown(self.watcher:IsVisible() and not self:GetAttribute("statehidden"))
end

local function createPetActionButton(name, id)
    local button = CreateFrame('CheckButton', name, nil, 'PetActionButtonTemplate')

    Mixin(button, PetActionButtonMixin)

    -- get the stock button
    local petActionButton = _G['PetActionButton' .. id]

    -- copy its ID
    button:SetID(petActionButton:GetID())

    -- copy its visibility state
    local watcher = CreateFrame('Frame', nil, petActionButton, "SecureHandlerShowHideTemplate")
    watcher:SetFrameRef("owner", button)
    watcher:SetAttribute("_onshow", [[ self:GetFrameRef("owner"):Show(true) ]])
    watcher:SetAttribute("_onhide", [[ self:GetFrameRef("owner"):Hide(true) ]])
    button.watcher = watcher

    -- copy its pushed state
    hooksecurefunc(petActionButton, "SetButtonState", function(_, ...)
        button:SetButtonState(...)
    end)

    -- setup bindings
    button.commandName = ("BONUSACTIONBUTTON%d"):format(id)
    Addon.BindableButton:AddQuickBindingSupport(button)

    -- add support for mousewheel bindings
    button:EnableMouseWheel(true)

    -- unregister spell data loaded callback
    button:HookScript("OnHide", PetActionButtonMixin.CancelSpellDataLoadedCallback)

    return button
end

local function getOrCreatePetActionButton(id)
    local name = ('%sPetActionButton%d'):format(AddonName, id)
    local button = _G[name]

    if not button then
        button = createPetActionButton(name, id)
    end

    return button
end

--------------------------------------------------------------------------------
-- The Pet Bar
--------------------------------------------------------------------------------

local PetBar = Addon:CreateClass('Frame', Addon.ButtonBar)

function PetBar:New()
    return PetBar.proto.New(self, 'pet')
end

function PetBar:GetDisplayName()
    return L.PetBarDisplayName
end

function PetBar:IsOverrideBar()
    return Addon.db.profile.possessBar == self.id
end

function PetBar:UpdateOverrideBar()
end

function PetBar:GetDefaults()
    return {
        point = 'CENTER',
        x = 0,
        y = -32,
        spacing = 6
    }
end

function PetBar:NumButtons()
    return NUM_PET_ACTION_SLOTS
end

function PetBar:AcquireButton(index)
    return getOrCreatePetActionButton(index)
end

function PetBar:OnAttachButton(button)
    button:UpdateHotkeys()
    button:UpdateShownInsecure()

    Addon:GetModule('ButtonThemer'):Register(button, 'Pet Bar')
    Addon:GetModule('Tooltips'):Register(button)
end

function PetBar:OnDetachButton(button)
    Addon:GetModule('ButtonThemer'):Unregister(button, 'Pet Bar')
    Addon:GetModule('Tooltips'):Unregister(button)
end

-- keybound events
function PetBar:KEYBOUND_ENABLED()
    self:ForButtons("UpdateShownInsecure")
end

function PetBar:KEYBOUND_DISABLED()
    self:ForButtons("UpdateShownInsecure")
end

--------------------------------------------------------------------------------
-- the module
--------------------------------------------------------------------------------

local PetBarModule = Addon:NewModule('PetBar', 'AceEvent-3.0')

function PetBarModule:Load()
    if not self.loaded then
        self:OnFirstLoad()
        self.loaded = true
    end

    self.bar = PetBar:New()
    self:UpdateActions()
    self:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
end

function PetBarModule:Unload()
    self:UnregisterAllEvents()

    if self.bar then
        self.bar:Free()
        self.bar = nil
    end
end

function PetBarModule:OnFirstLoad()
    -- "hide" the pet bar (make invisible and non-interactive)
    PetActionBar:SetAlpha(0)
    PetActionBar:EnableMouse(false)
    PetActionBar:SetScript("OnUpdate", nil)

    -- and its buttons, too
    for _, button in pairs(PetActionBar.actionButtons) do
        button:EnableMouse(false)
        button:SetScript("OnUpdate", nil)
        button:UnregisterAllEvents()
    end

    -- unregister events that do not impact pet action bar visibility
    PetActionBar:UnregisterEvent("PET_BAR_UPDATE_COOLDOWN")

    -- an extremly lazy method of updating the Dominos pet bar when the
    -- normal pet bar would be updated
    hooksecurefunc(PetActionBar, "Update", Addon:Defer(function() self:UpdateActions() end, 0.01))
end

function PetBarModule:PET_BAR_UPDATE_COOLDOWN()
    self:UpdateCooldowns()
end

function PetBarModule:UpdateActions()
    if not (self.bar and PetHasActionBar() and UnitIsVisible("pet")) then return end

    self.bar:ForButtons("Update")
end

function PetBarModule:UpdateCooldowns()
    if not (self.bar and PetHasActionBar() and UnitIsVisible("pet")) then return end

    self.bar:ForButtons("UpdateCooldown")
end
