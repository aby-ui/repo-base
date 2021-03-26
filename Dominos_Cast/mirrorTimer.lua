local _, Addon = ...
local Dominos = LibStub('AceAddon-3.0'):GetAddon('Dominos')
local LSM = LibStub('LibSharedMedia-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-CastBar')

local GetMirrorTimerProgress = _G.GetMirrorTimerProgress

local MirrorTimer = Dominos:CreateClass('Frame', Dominos.Frame)

---@param id number
---@return table mirrorTimer
function MirrorTimer:New(id, ...)
    local mirrorTimer = MirrorTimer.proto.New(self, 'mirrorTimer' .. id, ...)

    mirrorTimer:Layout()
    mirrorTimer:RegisterEvents()
    mirrorTimer.timerID = id

    return mirrorTimer
end

function MirrorTimer:OnCreate()
    MirrorTimer.proto.OnCreate(self)

    self:SetScript('OnEvent', self.OnEvent)

    self.props = {}
    self.timer = CreateFrame('Frame', nil, self, 'DominosTimerBarTemplate')

    self.timer.OnUpdate = function(timer)
        if self.timerName then
            local value = (GetMirrorTimerProgress(self.timerName) or 0) / 1000
            timer:SetValue(value)
        else
            timer:SetValue(0)
        end
    end
end

function MirrorTimer:OnRelease()
    MirrorTimer.proto.OnRelease(self)

    LSM.UnregisterAllCallbacks(self)
end

function MirrorTimer:OnLoadSettings()
    self:SetProperty('font', self:GetFontID())
    self:SetProperty('texture', self:GetTextureID())
end

---@return table defaults
function MirrorTimer:GetDefaults()
    return {
        point = 'TOP',
        x = 0,
        y = -96 - ((tonumber(strmatch(self.id, '%d')) - 1) * 26),
        padW = 1,
        padH = 1,
        w = 206,
        h = 26,
        font = LSM:GetDefault(LSM.MediaType.FONT),
        texture = LSM:GetDefault(LSM.MediaType.STATUSBAR),
        displayLayer = 'HIGH',
        display = {
            label = true,
            time = false,
            border = true,
            spark = false
        }
    }
end

function MirrorTimer:GetDisplayName()
    return L.MirrorTimerDisplayName:format(self.timerID)
end

---@param event string
function MirrorTimer:OnEvent(event, ...)
    local func = self[event]
    if func then
        func(self, ...)
    end
end

function MirrorTimer:RegisterEvents()
    LSM.RegisterCallback(self, 'LibSharedMedia_Registered')
end

function MirrorTimer:LibSharedMedia_Registered(event, mediaType, key)
    if mediaType == LSM.MediaType.FONT and key == self:GetFontID() then
        self:font_update(key)
    elseif mediaType == LSM.MediaType.STATUSBAR and key == self:GetTextureID() then
        self:texture_update(key)
    end
end

---@param fontID any
function MirrorTimer:font_update(fontID)
    self.timer:SetFont(fontID)
end

---@param textureID any
function MirrorTimer:texture_update(textureID)
    self.timer:SetTexture(textureID)
end

---@param key string
---@param value any
function MirrorTimer:SetProperty(key, value)
    local prev = self.props[key]

    if prev ~= value then
        self.props[key] = value

        local func = self[key .. '_update']
        if func then
            func(self, value, prev)
        end
    end
end

---@param key string
---@return any value
function MirrorTimer:GetProperty(key)
    return self.props[key]
end

function MirrorTimer:Layout()
    self:TrySetSize(self:GetDesiredWidth(), self:GetDesiredHeight())

    self.timer:SetPadding(self:GetPadding())
    self.timer:SetShowText(self:Displaying('time'))
    self.timer:SetShowBorder(self:Displaying('border'))
    self.timer:SetShowSpark(self:Displaying('spark'))
    self.timer:SetShowLatency(false)
    self.timer:SetShowIcon(false)
end

---@param width number
function MirrorTimer:SetDesiredWidth(width)
    self.sets.w = tonumber(width)
    self:Layout()
end

---@return number width
function MirrorTimer:GetDesiredWidth()
    return self.sets.w or 200
end

---@param height number
function MirrorTimer:SetDesiredHeight(height)
    self.sets.h = tonumber(height)
    self:Layout()
end

---@return number height
function MirrorTimer:GetDesiredHeight()
    return self.sets.h or 20
end

---@param fontID any
function MirrorTimer:SetFontID(fontID)
    self.sets.font = fontID
    self:SetProperty('font', self:GetFontID())

    return self
end

---@return any fontID
function MirrorTimer:GetFontID()
    return self.sets.font or LSM:GetDefault(LSM.MediaType.FONT)
end

---@param textureID any
function MirrorTimer:SetTextureID(textureID)
    self.sets.texture = textureID
    self:SetProperty('texture', self:GetTextureID())

    return self
end

---@return any textureID
function MirrorTimer:GetTextureID()
    return self.sets.texture or LSM:GetDefault(LSM.MediaType.STATUSBAR)
end

---@param part string
---@param enable boolean
function MirrorTimer:SetDisplay(part, enable)
    self.sets.display[part] = enable
    self:Layout()
end

---@param part string
---@return boolean enabled
function MirrorTimer:Displaying(part)
    return self.sets.display[part]
end

---@param timerName string
---@param value number
---@param maxValue number
---@param scale number
---@param paused number
---@param timerLabel string
function MirrorTimer:Start(timerName, value, maxValue, scale, paused, timerLabel)
    if not (self.timerName == nil or self.timerName == timerName) then
        return false
    end

    self.timerName = timerName

    self.timer:SetLabel(timerLabel)
    self.timer:SetCountdown(scale < 0)
    self.timer:Start(value / 1000, 0, maxValue / 1000)

    local color = MirrorTimerColors[timerName]
    self.timer.statusBar:SetStatusBarColor(color.r, color.g, color.b)

    if paused > 0 then
        self.timer:Pause()
    end

    return true
end

function MirrorTimer:Stop(timerName)
    if self.timerName ~= timerName then
        return false
    end

    self.timer:Stop()
    self.timerName = nil
    return true
end

function MirrorTimer:Pause(timerName, paused)
    if self.timerName ~= timerName then
        return false
    end

    if paused > 0 then
        self.timer:Pause()
    else
        self:Update()
    end

    return true
end

function MirrorTimer:Update()
    local timerName, value, maxValue, scale, paused, timerLabel = GetMirrorTimerInfo(self.timerID)

    if timerName == 'UNKNOWN' then
        self.timerName = nil
        self.timer:Stop()
        return
    end

    self.timer:SetCountdown(scale < 0)
    self:Start(timerName, value, maxValue, scale, paused, timerLabel)
end

function MirrorTimer:OnCreateMenu(menu)
    self:AddLayoutPanel(menu)
    self:AddTexturePanel(menu)
    self:AddFontPanel(menu)
	menu:AddFadingPanel()
	menu:AddAdvancedPanel(true)

    self.menu = menu

    self.menu:HookScript(
        'OnShow',
        function()
            self:Start('BREATH', random(20, 60) * 1000, 60000, -1, 1, BREATH_LABEL)
        end
    )

    self.menu:HookScript(
        'OnHide',
        function()
            self:Update()
        end
    )
end

---@param menu table
function MirrorTimer:AddLayoutPanel(menu)
    local panel = menu:NewPanel(LibStub('AceLocale-3.0'):GetLocale('Dominos-Config').Layout)

    for i, part in pairs({'label', 'time', 'border'}) do
        panel:NewCheckButton(
            {
                name = L['Display_' .. part],
                get = function()
                    return panel.owner:Displaying(part)
                end,
                set = function(_, enable)
                    panel.owner:SetDisplay(part, enable)
                end
            }
        )
    end

    panel.widthSlider =
        panel:NewSlider(
        {
            name = L.Width,
            min = 1,
            max = function()
                return math.ceil(_G.UIParent:GetWidth() / panel.owner:GetScale())
            end,
            get = function()
                return panel.owner:GetDesiredWidth()
            end,
            set = function(_, value)
                panel.owner:SetDesiredWidth(value)
            end
        }
    )

    panel.heightSlider =
        panel:NewSlider(
        {
            name = L.Height,
            min = 1,
            max = function()
                return math.ceil(_G.UIParent:GetHeight() / panel.owner:GetScale())
            end,
            get = function()
                return panel.owner:GetDesiredHeight()
            end,
            set = function(_, value)
                panel.owner:SetDesiredHeight(value)
            end
        }
    )

    panel:AddBasicLayoutOptions()
end

---@param menu table
function MirrorTimer:AddFontPanel(menu)
    local panel = menu:NewPanel(L.Font)

    panel.fontSelector =
        Dominos.Options.FontSelector:New(
        {
            parent = panel,
            get = function()
                return panel.owner:GetFontID()
            end,
            set = function(_, value)
                panel.owner:SetFontID(value)
            end
        }
    )
end

---@param menu table
function MirrorTimer:AddTexturePanel(menu)
    local panel = menu:NewPanel(L.Texture)

    panel.textureSelector =
        Dominos.Options.TextureSelector:New(
        {
            parent = panel,
            get = function()
                return panel.owner:GetTextureID()
            end,
            set = function(_, value)
                panel.owner:SetTextureID(value)
            end
        }
    )
end

--[[ exports ]]
Addon.MirrorTimer = MirrorTimer
