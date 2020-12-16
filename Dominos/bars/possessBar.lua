local PossessBarFrame = _G.PossessBarFrame
if not PossessBarFrame then return end

--------------------------------------------------------------------------------
-- Possess bar
-- Lets you move around the bar for displaying possess abilities
--------------------------------------------------------------------------------

local AddonName, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

--------------------------------------------------------------------------------
-- Button setup
--------------------------------------------------------------------------------

local function getPossessButton(id)
    return _G[('PossessButton%d'):format(id)]
end

for id = 1, _G.NUM_POSSESS_SLOTS do
    local button = getPossessButton(id)

    -- add quick binding support
    Addon.BindableButton:AddQuickBindingSupport(button)
end

--------------------------------------------------------------------------------
-- Bar setup
--------------------------------------------------------------------------------

local PossessBar = Addon:CreateClass('Frame', Addon.ButtonBar)

function PossessBar:New()
    return PossessBar.proto.New(self, 'possess')
end

PossessBar:Extend(
    'OnCreate',
    function(self)
        -- set display states for when the PossessBarFrame is shown/hidden
        local watcher = _G.CreateFrame('Frame', nil, PossessBarFrame, 'SecureHandlerShowHideTemplate')

        watcher:SetFrameRef('owner', self)

        watcher:SetAttribute('_onshow', [[
            self:GetFrameRef('owner'):SetAttribute('state-display', 'show')
        ]])

        watcher:SetAttribute('_onhide', [[
            self:GetFrameRef('owner'):SetAttribute('state-display', 'hide')
        ]])

        self.watcher = watcher

        -- also check when entering/leaving combat
        -- this works as a delayed initializer as well
        self:SetFrameRef('PossessBarFrame', PossessBarFrame)

        self:SetAttribute('_onstate-combat', [[
            if self:GetFrameRef('PossessBarFrame'):IsShown() then
                self:SetAttribute('state-display', 'show')
            else
                self:SetAttribute('state-display', 'hide')
            end
        ]])

        RegisterStateDriver(self, 'combat', '[combat]1;0')
    end
)


function PossessBar:GetDisplayName()
    return L.PossessBarDisplayName
end

-- disable UpdateDisplayConditions as we're not using showstates for this
function PossessBar:UpdateDisplayConditions() end

function PossessBar:GetDefaults()
    return {
        point = 'CENTER',
        x = 244,
        y = 0,
        spacing = 4,
        padW = 2,
        padH = 2
    }
end

function PossessBar:NumButtons()
    return _G.NUM_POSSESS_SLOTS
end

function PossessBar:AcquireButton(index)
    return getPossessButton(index)
end

function PossessBar:OnAttachButton(button)
    button:UpdateHotkeys()

    Addon:GetModule('ButtonThemer'):Register(button, L.PossessBarDisplayName)
    Addon:GetModule('Tooltips'):Register(button)
end

function PossessBar:OnDetachButton(button)
    Addon:GetModule('ButtonThemer'):Unregister(button, L.PossessBarDisplayName)
    Addon:GetModule('Tooltips'):Unregister(button)
end

-- export
Addon.PossessBar = PossessBar

--------------------------------------------------------------------------------
-- Module
--------------------------------------------------------------------------------

local PossessBarModule = Addon:NewModule('PossessBar', 'AceEvent-3.0')

function PossessBarModule:Load()
    if not self.initialized then
        self:DisablePossessBarFrame()
        self.initialized = true
    end

    self.bar = PossessBar:New()
    self:RegisterEvent('UPDATE_BINDINGS')
end

function PossessBarModule:Unload()
    self:UnregisterAllEvents()

    if self.bar then
        self.bar:Free()
    end
end

function PossessBarModule:UPDATE_BINDINGS()
    self.bar:ForButtons('UpdateHotkeys')
end

function PossessBarModule:DisablePossessBarFrame()
    -- make the bar not movable/clickable
    PossessBarFrame.ignoreFramePositionManager = true
    PossessBarFrame:EnableMouse(false)
    PossessBarFrame:SetParent(nil)

    -- hide artwork
    hooksecurefunc('PossessBar_UpdateState', function()
        _G.PossessBackground1:Hide()
        _G.PossessBackground2:Hide()
    end)

    -- note, don't clear points on the possess bar because the stock UI has
    -- logic that depends on the bar having a position
    -- PossessBarFrame:ClearAllPoints()
end
