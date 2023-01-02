local BlizzardStanceBar = _G.StanceBar
if not BlizzardStanceBar then return end

--------------------------------------------------------------------------------
-- Stance bar
-- Lets you move around the bar for displaying forms/stances/etc
--------------------------------------------------------------------------------

local AddonName, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

-- test to see if the player has a stance bar
-- not the best looking, but I also don't need to keep it after I do the check
if not ({
    DEATHKNIGHT = Addon:IsBuild('wrath'),
    DEMONHUNTER = false,
    DRUID = true,
    EVOKER = false,
    HUNTER = false,
    MAGE = false,
    MONK = false,
    PALADIN = true,
    PRIEST = Addon:IsBuild('retail', 'wrath'),
    ROGUE = true,
    SHAMAN = false,
    WARLOCK = Addon:IsBuild('wrath'),
    WARRIOR = true,
})[UnitClassBase('player')] then
    return
end
--------------------------------------------------------------------------------
-- Bar setup
--------------------------------------------------------------------------------

local StanceBar = Addon:CreateClass('Frame', Addon.ButtonBar)

function StanceBar:New()
    return StanceBar.proto.New(self, 'class')
end

function StanceBar:GetDisplayName()
    return L.ClassBarDisplayName
end

function StanceBar:GetDefaults()
    return {
        point = 'CENTER',
        spacing = 2
    }
end

function StanceBar:NumButtons()
    return GetNumShapeshiftForms() or 0
end

function StanceBar:AcquireButton(index)
    return BlizzardStanceBar.actionButtons[index]
end

function StanceBar:OnAttachButton(button)
    button:Show()
    button:UpdateHotkeys()

    Addon:GetModule('ButtonThemer'):Register(button, 'Class Bar')
    Addon:GetModule('Tooltips'):Register(button)
end

function StanceBar:OnDetachButton(button)
    Addon:GetModule('ButtonThemer'):Unregister(button, 'Class Bar')
    Addon:GetModule('Tooltips'):Unregister(button)
end

-- export
Addon.StanceBar = StanceBar

--------------------------------------------------------------------------------
-- Module
--------------------------------------------------------------------------------

local StanceBarModule = Addon:NewModule('StanceBar', 'AceEvent-3.0')

function StanceBarModule:Load()
    if not self.loaded then
        self:OnFirstLoad()
        self.loaded = true
    end

    self.bar = StanceBar:New()

    self:RegisterEvent("PLAYER_ENTERING_WORLD", 'UpdateNumForms')
    self:RegisterEvent("PLAYER_REGEN_ENABLED", 'UpdateNumForms')
end

function StanceBarModule:Unload()
    self:UnregisterAllEvents()

    if self.bar then
        self.bar:Free()
    end
end

function StanceBarModule:OnFirstLoad()
    -- hide the existing stance bar
    BlizzardStanceBar:SetParent(Addon.ShadowUIParent)

    -- wipe buttons and spacers to avoid layout updates from the stock ui
    table.wipe(BlizzardStanceBar.buttonsAndSpacers)

    for _, button in pairs(BlizzardStanceBar.actionButtons) do
        -- turn off cooldown edges
        button.cooldown:SetDrawEdge(false)

        -- turn off constant usability updates
        button:SetScript("OnUpdate", nil)

        -- register mouse clicks
        button:EnableMouseWheel(true)

        -- apply hooks for quick binding
        Addon.BindableButton:AddQuickBindingSupport(button)
    end
end

function StanceBarModule:UpdateNumForms()
    if not InCombatLockdown() then
        self.bar:UpdateNumButtons()
    end
end
