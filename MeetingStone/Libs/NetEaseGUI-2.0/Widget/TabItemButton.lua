--[[
TabItemButton.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local WIDGET, VERSION = 'TabItemButton', 1

local GUI = LibStub('NetEaseGUI-2.0')
local TabItemButton = GUI:NewClass(WIDGET, GUI:GetClass('ItemButton'), VERSION)
if not TabItemButton then
    return
end

function TabItemButton:StartFlash()
    if not self.Flash then
        self.Flash = self:GetFlashClass():New(self)
        self.Flash:Hide()
        self:FireHandler('OnFlashCreated', self.Flash)
    end
    self.Flash:Show()
end

function TabItemButton:StopFlash()
    if not self.Flash then
        return
    end
    self.Flash:Hide()
end

function TabItemButton:SetFlashClass(class)
    self.FlashClass = class
end

function TabItemButton:GetFlashClass()
    return self.FlashClass or GUI:GetClass('AlphaFlash')
end
