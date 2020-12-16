local VehicleLeaveButton = _G.MainMenuBarVehicleLeaveButton
if not VehicleLeaveButton then
    return
end

local AddonName, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

local CanExitVehicle = _G.CanExitVehicle
if not CanExitVehicle then
    CanExitVehicle = function()
        return UnitOnTaxi('player')
    end
end

-- bar
local VehicleBar = Addon:CreateClass('Frame', Addon.Frame)

function VehicleBar:New()
    return VehicleBar.proto.New(self, "vehicle")
end

function VehicleBar:GetDisplayName()
    return L.VehicleDisplayName --return _G.BINDING_NAME_VEHICLEEXIT
end

VehicleBar:Extend('OnAcquire', function(self)
	self:Layout()
end)

function VehicleBar:GetDefaults()
    return {
        point = 'CENTER',
        x = -244,
        y = 0
    }
end

function VehicleBar:Layout()
    VehicleLeaveButton:ClearAllPoints()
    VehicleLeaveButton:SetPoint('CENTER', self)
    VehicleLeaveButton:SetParent(self)

    local w, h = VehicleLeaveButton:GetSize()
    local pW, pH = self:GetPadding()

    self:TrySetSize(w + pW, h + pH)
end

function VehicleBar:OnCreateMenu(menu)
    self:AddLayoutPanel(menu)

    menu:AddFadingPanel()
    menu:AddAdvancedPanel(true)
end

function VehicleBar:AddLayoutPanel(menu)
    local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

    local panel = menu:NewPanel(l.Layout)

    panel.scaleSlider = panel:NewScaleSlider()
    panel.paddingSlider = panel:NewPaddingSlider()
end

-- module
local VehicleBarModule = Addon:NewModule('VehicleBar', 'AceEvent-3.0')

function VehicleBarModule:OnInitialize()
    -- MainMenuBarVehicleLeaveButton_Update can alter the position of the leave
    -- button, so put it back on the vehicle bar whenever it is called
    -- we also show it again, if possible, because it'll be hidden normally if
    -- the Override UI is enabled.
    hooksecurefunc(
        'MainMenuBarVehicleLeaveButton_Update',
        Addon:Defer(
            function()
                if self.frame then
                    VehicleLeaveButton:ClearAllPoints()
                    VehicleLeaveButton:SetPoint('CENTER', self.frame)

                    if CanExitVehicle() then
                        VehicleLeaveButton:Show()
                    end
                end
            end,
            0.01
        )
    )
end

function VehicleBarModule:Load()
    self.frame = VehicleBar:New()
end

function VehicleBarModule:Unload()
    if self.frame then
        self.frame:Free()
        self.frame = nil
    end
end
