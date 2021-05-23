--------------------------------------------------------------------------------
-- Pet Bar
-- A movable action bar for pets
--------------------------------------------------------------------------------

local AddonName, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

--------------------------------------------------------------------------------
-- Pet Button Setup
--------------------------------------------------------------------------------

local function getPetButton(id)
    return _G[('PetActionButton%d'):format(id)]
end

for id = 1, NUM_PET_ACTION_SLOTS do
    local button = getPetButton(id)

    Addon.BindableButton:AddQuickBindingSupport(button, ('BONUSACTIONBUTTON%d'):format(id))
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

if Addon:IsBuild('bcc', 'classic') then
    function PetBar:GetDisplayConditions()
        return '[pet]show;hide'
    end
else
    function PetBar:GetDisplayConditions()
        return '[@pet,exists,nopossessbar]show;hide'
    end
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
    return getPetButton(index)
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
    self:ForButtons("Show")
end

function PetBar:KEYBOUND_DISABLED()
    local petBarShown = PetHasActionBar()

    for _, button in pairs(self.buttons) do
        if petBarShown and GetPetActionInfo(button:GetID()) then
            button:Show()
        else
            button:Hide()
        end
    end
end

--------------------------------------------------------------------------------
-- the module
--------------------------------------------------------------------------------

local PetBarModule = Addon:NewModule('PetBar', 'AceEvent-3.0')

function PetBarModule:Load()
    self.bar = PetBar:New()

    self:RegisterEvent('UPDATE_BINDINGS')
end

function PetBarModule:Unload()
    self:UnregisterAllEvents()

    if self.bar then
        self.bar:Free()
        self.bar = nil
    end
end

function PetBarModule:UPDATE_BINDINGS()
    self.bar:ForButtons('UpdateHotkeys')
end
