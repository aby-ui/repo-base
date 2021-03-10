-- code to drive the addon
local ADDON, Addon = ...
local CONFIG_ADDON = ADDON .. '_Config'
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

function Addon:OnLoad()
    -- create and setup options frame and event loader
    local frame = self:CreateHiddenFrame('Frame')

    -- setup an event handler
    frame:SetScript(
        'OnEvent',
        function(_, event, ...)
            local func = self[event]
            if type(func) == 'function' then
                func(self, event, ...)
            end
        end
    )

    frame:RegisterEvent('ADDON_LOADED')
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('PLAYER_LOGIN')
    frame:RegisterEvent('PLAYER_LOGOUT')

    -- setup the config ui loader
    if self:IsConfigAddonEnabled() then
        frame.name = ADDON

        -- load the config addon when this frame is shown
        frame:SetScript(
            'OnShow',
            function(f)
                f:SetScript('OnShow', nil)
                LoadAddOn(CONFIG_ADDON)
            end
        )

        InterfaceOptions_AddCategory(frame)
    end

    self.frame = frame

    -- setup slash commands
    _G[('SLASH_%s1'):format(ADDON)] = ('/%s'):format(ADDON:lower())
    _G[('SLASH_%s2'):format(ADDON)] = '/occ'

    SlashCmdList[ADDON] = function(cmd, ...)
        if cmd == 'version' then
            print(L.Version:format(self.db.global.addonVersion))
        else
            self:ShowOptionsFrame()
        end
    end

    self.OnLoad= nil
end

-- events
function Addon:ADDON_LOADED(event, addonName)
    if ADDON ~= addonName then
        return
    end

    self.frame:UnregisterEvent(event)

    self:InitializeDB()
    self.Cooldown:SetupHooks()
end

function Addon:PLAYER_ENTERING_WORLD()
    self.Timer:ForActive('Update')
end

function Addon:PLAYER_LOGIN()
    if not self.db.global.disableBlizzardCooldownText then return end

    -- disable and preserve the user's blizzard cooldown count setting
    self.countdownForCooldowns = GetCVar('countdownForCooldowns')
    if self.countdownForCooldowns ~= '0' then
        SetCVar('countdownForCooldowns', '0')
    end
end

function Addon:PLAYER_LOGOUT()
    if not self.db.global.disableBlizzardCooldownText then return end

    -- return the setting to whatever it was originally on logout
    -- so that the user can uninstall omnicc and go back to what they had
    local countdownForCooldowns = GetCVar('countdownForCooldowns')
    if self.countdownForCooldowns ~= countdownForCooldowns then
        SetCVar('countdownForCooldowns', self.countdownForCooldowns)
    end
end

-- utility methods
function Addon:ShowOptionsFrame()
    if self:IsConfigAddonEnabled() then
        if not InterfaceOptionsFrame:IsShown() then
            InterfaceOptionsFrame_Show()
        end

        InterfaceOptionsFrame_OpenToCategory(self.frame)
        return true
    end

    return false
end

function Addon:IsConfigAddonEnabled()
    if GetAddOnEnableState(UnitName('player'), CONFIG_ADDON) >= 1 then
        return true
    end

    return false
end

function Addon:CreateHiddenFrame(...)
    local f = CreateFrame(...)

    f:Hide()

    return f
end

function Addon:GetButtonIcon(frame)
    if frame then
        local icon = frame.icon
        if type(icon) == 'table' and icon.GetTexture then
            return icon
        end

        local name = frame:GetName()
        if name then
            icon = _G[name .. 'Icon'] or _G[name .. 'IconTexture']

            if type(icon) == 'table' and icon.GetTexture then
                return icon
            end
        end
    end
end

Addon:OnLoad()

-- exports
_G[ADDON] = Addon
