
local assert, pairs, select, tonumber, type = assert, pairs, select, tonumber, type
local strsplit, strupper = string.split, string.upper
local tdCore = tdCore

local GetAddOnMetadata = GetAddOnMetadata
local GetAddOnInfo = GetAddOnInfo

local Addon = tdCore:NewLibrary('Addon', tdCore.Addon, 1)
Addon:RegisterHandle('OnProfileUpdate', 'OnSlashCmd')

local addons = {}

function Addon:New(name, addon, version)
    assert(type(name) == 'string', 'Bad argument #1 to `New\' (string expected)')
    
    if not addons[name] then
        addon = self:Bind(addon or {})
        
        addon.__version = tonumber(version) or tonumber(GetAddOnMetadata(name, 'Version')) or 1
        addon.__name = name
        addon.__title = U1GetAddonInfo and U1GetAddonInfo(name) and U1GetAddonInfo(name).title or select(2, GetAddOnInfo(name))
        addon.__modules = {}
        
        addons[name] = addon
    end
    return addons[name]
end

function Addon:Get(name)
    assert(type(name) == 'string', 'Bad argument #1 to `New\' (string expected)')
    
    return addons[name]
end

function Addon:IterateAddons()
    return pairs(addons)
end

function Addon:GetName()
    return self.__name
end

function Addon:GetTitle()
    return self.__title
end

function Addon:GetVersion()
    return self.__version
end

function Addon:Debug(...)
    tdCore:Debug(self:GetName(), ...)
end

------ locale

function Addon:NewLocale(locale)
    return tdCore.Locale:New(self:GetName(), locale)
end

function Addon:GetLocale()
    return tdCore.Locale:Get(self:GetName())
end

------ db

function Addon:InitDB(name, defaultProfile, reloaduiWhileReset)
    self.__db = tdCore.DB:New(name, defaultProfile)
    self.__db:NewProfile()
    self.__reloaduiWhileReset = reloaduiWhileReset
end

function Addon:GetDB()
    return self.__db
end

function Addon:GetProfile()
    return self:GetDB() and self:GetDB():GetCurrentProfile()
end

function Addon:UpdateProfile()
    self:RunHandle('OnProfileUpdate')
    for i, module in self:IterateModules() do
        module:RunHandle('OnProfileUpdate')
    end
end

------ command

function Addon:RegisterCmd(...)
    local name = strupper(self:GetName())
    
    for i = 1, select('#', ...) do
        _G['SLASH_' .. name .. i] = select(i, ...)
    end
    
    SlashCmdList[name] = function(text)
        self:RunHandle('OnSlashCmd', strsplit(' ', (text or ''):lower()))
    end
end
