local BlizzardPetBar = _G.PetActionBar
if not BlizzardPetBar then return end

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

function PetBar:GetDisplayConditions()
    -- workaround: filter out channeling of eye of kilrog when playing a warlock
    -- as it doesn't trigger the possess bar condition properly if you already
    -- have a pet summoned
    if UnitClassBase("player") == "WARLOCK" then
        local eyeOfKilrogg = GetSpellInfo(126)
        return ('[channeling:%s]hide;[@pet,exists,nopossessbar]show;hide'):format(eyeOfKilrogg)
    end

    return '[@pet,exists,nopossessbar]show;hide'
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
    return #BlizzardPetBar.actionButtons
end

function PetBar:AcquireButton(index)
    return BlizzardPetBar.actionButtons[index]
end

function PetBar:OnAttachButton(button)
    button:UpdateHotkeys()
    Addon:GetModule('ButtonThemer'):Register(button, 'Pet Bar')
    Addon:GetModule('Tooltips'):Register(button)
end

function PetBar:OnDetachButton(button)
    Addon:GetModule('ButtonThemer'):Unregister(button, 'Pet Bar')
    Addon:GetModule('Tooltips'):Unregister(button)
end

-- keybound events
function PetBar:KEYBOUND_ENABLED()
    if InCombatLockdown() then
        return
    end

    for _, button in pairs(self.buttons) do
        button:SetShown(true)
    end
end

function PetBar:KEYBOUND_DISABLED()
    if InCombatLockdown() then
        return
    end

    for _, button in pairs(self.buttons) do
        button:SetShown(button:GetAttribute("showgrid") > 0)
    end
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
end

function PetBarModule:Unload()
    self:UnregisterAllEvents()

    if self.bar then
        self.bar:Free()
        self.bar = nil
    end
end

function PetBarModule:OnFirstLoad()
    BlizzardPetBar:SetParent(Addon.ShadowUIParent)

    -- wipe buttons and spacers to avoid layout updates from the stock ui
    table.wipe(BlizzardPetBar.buttonsAndSpacers)

    for _, button in pairs(BlizzardPetBar.actionButtons) do
        -- setup bindings
        Addon.BindableButton:AddQuickBindingSupport(button)

        -- add support for mousewheel bindings
        button:EnableMouseWheel(true)
    end
end
