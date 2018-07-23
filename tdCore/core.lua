
local lib, version = 'tdCore', 5

if _G[lib] and _G[lib].version >= version then return end

_G[lib] = {}

local tdCore = _G[lib]

tdCore.Addon = {}
tdCore.Locale = {}
tdCore.DB = {}

function tdCore:OnEvent(event, ...)
    if self[event] then
        self[event](self, event, ...)
    end
end

function tdCore:NewAddon(name, addon, version)
    return self.Addon:New(name, addon, version)
end

function tdCore:GetAddon(name)
    return self.Addon:Get(name)
end

function tdCore:NewLocale(name, locale)
    return self.Locale:New(name, locale)
end

function tdCore:GetLocale(name)
    return self.Locale:Get(name)
end

function tdCore:IterateAddons()
    return self.Addon:IterateAddons()
end

function tdCore:SetAllowDebug(allow)
    if IsAddOnLoaded('tdDebug') then
        self.__debug = allow
    end
end

function tdCore:GetAllowDebug()
    return self.__debug
end

function tdCore:Debug(name, ...)
    if self:GetAllowDebug() then
        self('tdDebug'):Add(name, debugstack(3):gsub(': in function.+$', ''), ...)
    end
end

local frame = CreateFrame('Frame') frame:Hide()

function frame:ADDON_LOADED(event, name)
    local addon = tdCore:GetAddon(name)
    if addon then
        if addon.OnInit then
            addon:OnInit()
        end
        
        for _, module in addon:IterateModules() do
            if module.OnInit then
                module:OnInit()
            end
        end
    end
end

function frame:PLAYER_LOGOUT()
    for _, addon in tdCore:IterateAddons() do
        if addon:GetDB() then
            addon:GetDB():RemoveDefault()
        end
    end
end

frame:SetScript('OnEvent', tdCore.OnEvent)
frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('PLAYER_LOGOUT')

setmetatable(tdCore, {__call = tdCore.GetAddon})
