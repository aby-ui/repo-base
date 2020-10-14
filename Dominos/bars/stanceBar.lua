--------------------------------------------------------------------------------
-- Stance bar
-- Lets you move around the bar for displaying forms/stances/etc
--------------------------------------------------------------------------------
local _, Addon = ...

-- test to see if the player has a stance bar
-- not the best looking, but I also don't need to keep it after I do the check
if not ({
    DEATHKNIGHT = false,
    DEMONHUNTER = false,
    DRUID = true,
    HUNTER = false,
    MAGE = false,
    MONK = false,
    PALADIN = true,
    PRIEST = Addon:IsBuild('retail'),
    ROGUE = true,
    SHAMAN = false,
    WARLOCK = false,
    WARRIOR = Addon:IsBuild('classic')
})[UnitClassBase('player')] then
    return
end

--------------------------------------------------------------------------------
-- Button setup
--------------------------------------------------------------------------------

local function getStanceButton(id)
    return _G[('StanceButton%d'):format(id)]
end

for id = 1, NUM_STANCE_SLOTS do
    local button = getStanceButton(id)

    -- fix hotkey text extending outside of the button itself
    -- and make it consistent with the button size
    if button.HotKey:GetWidth() > button:GetWidth() then
        button.HotKey:SetWidth(button:GetWidth())

        local font, size, flags = button.HotKey:GetFont()
        size = Round(size * button:GetWidth() / ActionButton1:GetWidth())

        button.HotKey:SetFont(font, size, flags)
    end

    -- add quick binding support
    Addon.BindableButton:AddQuickBindingSupport(button, ('SHAPESHIFTBUTTON%s'):format(id))
end

--------------------------------------------------------------------------------
-- Bar setup
--------------------------------------------------------------------------------

local StanceBar = Addon:CreateClass('Frame', Addon.ButtonBar)

function StanceBar:New()
    return StanceBar.proto.New(self, 'class')
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
    return getStanceButton(index)
end

function StanceBar:OnAttachButton(button)
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
    self.bar = StanceBar:New()

    self:RegisterEvent('UPDATE_SHAPESHIFT_FORMS', 'UpdateNumForms')
    self:RegisterEvent('PLAYER_REGEN_ENABLED', 'UpdateNumForms')
    self:RegisterEvent('PLAYER_ENTERING_WORLD', 'UpdateNumForms')
    self:RegisterEvent('UPDATE_BINDINGS')
end

function StanceBarModule:Unload()
    self:UnregisterAllEvents()

    if self.bar then
        self.bar:Free()
    end
end

function StanceBarModule:UpdateNumForms()
    if InCombatLockdown() then
        return
    end

    self.bar:UpdateNumButtons()
end

function StanceBarModule:UPDATE_BINDINGS()
    self.bar:ForButtons('UpdateHotkeys')
end
