
local tdOption = tdCore(...)

local addons = {}

local GUI = tdCore('GUI')
local Option = tdOption:NewModule('Option')

function Option:New(gui, addon, title)
    local obj = self:Bind{}
    
    obj.__addon = addon
    obj.__frame = GUI:CreateGUI(gui, tdOption('Frame'))
    
    tdOption('Frame'):AddOption(obj, title)
    
    return obj
end

function Option:GetTitle()
    return self:GetAddon():GetTitle()
end

function Option:GetAddon()
    return self.__addon
end

function Option:GetFrame()
    return self.__frame
end

function Option:GetDB()
    return self:GetAddon() and self:GetAddon():GetDB()
end

function Option:GetProfile()
    return self:GetAddon() and self:GetAddon():GetProfile()
end

function Option:GetControl(name)
    return self:GetFrame():GetControl(name)
end

function Option:Show()
    self:GetFrame():Show()
end

function Option:Hide()
    self:GetFrame():Hide()
end
