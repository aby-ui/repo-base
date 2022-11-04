if not MultiCastActionBarFrame then return end

--------------------------------------------------------------------------------
-- Totem bar
-- Lets you move around the bar for totems
--------------------------------------------------------------------------------

local AddonName, Addon = ...
if not (UnitClassBase('player') == 'SHAMAN' and Addon:IsBuild('wrath')) then
    return
end

--------------------------------------------------------------------------------
-- Bar setup
--------------------------------------------------------------------------------

local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

local TotemBar = Addon:CreateClass('Frame', Addon.Frame)

function TotemBar:New()
    return TotemBar.proto.New(self, 'totem')
end

function TotemBar:GetDisplayName()
    return L.TotemBarDisplayName
end

TotemBar:Extend('OnAcquire', function(self)
    local container = MultiCastActionBarFrame

    container:ClearAllPoints()
    container:SetPoint('CENTER', self)
    container:SetParent(self)

    self.container = container

    self:Layout()
end)

function TotemBar:GetDefaults()
    return {
        point = 'CENTER',
        spacing = 2
    }
end

function TotemBar:Layout()
    local w, h = self.container:GetSize()
    local pW, pH = self:GetPadding()

    self:SetSize(w + pW, h + pH)
end

function TotemBar:OnCreateMenu(menu)
    self:AddLayoutPanel(menu)

    menu:AddFadingPanel()
    menu:AddAdvancedPanel(true)
end

function TotemBar:AddLayoutPanel(menu)
    local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

    local panel = menu:NewPanel(l.Layout)

    panel:AddBasicLayoutOptions()
end

-- export
Addon.TotemBar = TotemBar

--------------------------------------------------------------------------------
-- Module
--------------------------------------------------------------------------------

local TotemBarModule = Addon:NewModule('TotemBar', 'AceEvent-3.0')

function TotemBarModule:Load()
    if not self.initialized then
        MultiCastActionBarFrame.ignoreFramePositionManager = true

        -- onshow/hide call UpdateManagedFramePositions on the blizzard end so
        -- turn that bit off
        MultiCastActionBarFrame:SetScript("OnShow", nil)
        MultiCastActionBarFrame:SetScript("OnHide", nil)

        -- also, it is repositioned on every frame? that seems silly
        MultiCastActionBarFrame:SetScript("OnUpdate", nil)

        self.initialized = true
    end

    self.bar = TotemBar:New()
end

function TotemBarModule:Unload()
    if self.bar then
        self.bar:Free()
        self.bar = nil
    end
end
