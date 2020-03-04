local Addon = (select(2, ...))
local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")
local LSM = LibStub("LibSharedMedia-3.0")

local SPARK_ALPHA = 0.7

local MirrorTimer = Dominos:CreateClass("Frame", Dominos.Frame)

---@param id number
---@return table mirrorTimer
function MirrorTimer:New(id, ...)
    local mirrorTimer = MirrorTimer.proto.New(self, "mirrorTimer" .. id, ...)

    mirrorTimer:Layout()
    mirrorTimer:RegisterEvents()

    return mirrorTimer
end

function MirrorTimer:OnCreate()
    self:SetFrameStrata("HIGH")
    self:SetScript("OnEvent", self.OnEvent)

	local container = CreateFrame('Frame', nil, self)
    container:SetAllPoints(container:GetParent())
    container:Hide()

    self.container = container

    local bg = container:CreateTexture(nil, "BACKGROUND")
    bg:SetVertexColor(0, 0, 0, 0.5)
    self.bg = bg

    local sb = CreateFrame("StatusBar", nil, container)
    sb:SetScript("OnValueChanged", function(_, value)
        self:OnValueChanged(value)
    end)

    local timeText = sb:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    timeText:SetJustifyH("RIGHT")
    self.timeText = timeText

    local labelText = sb:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    labelText:SetJustifyH("LEFT")
    self.labelText = labelText

    local spark = CreateFrame("StatusBar", nil, sb)

    local st = spark:CreateTexture(nil, "ARTWORK")
    st:SetColorTexture(1, 1, 1, SPARK_ALPHA)
    st:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0, 1, 1, 1, SPARK_ALPHA)
    st:SetBlendMode("BLEND")
    st:SetHorizTile(true)

    spark:SetStatusBarTexture(st)

    spark:SetAllPoints(sb)
    self.spark = spark

    self.statusBar = sb

    local border = CreateFrame("Frame", nil, container)

    border:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
    border:SetFrameLevel(sb:GetFrameLevel() + 3)
    border:SetAllPoints()
    border:SetBackdrop{
        edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
        edgeSize = 16,
        insets = {left = 5, right = 5, top = 5, bottom = 5},
    }

    self.border = border

    self.props = {}

    return self
end

function MirrorTimer:OnFree()
    self:UnregisterAllEvents()
    LSM.UnregisterAllCallbacks(self)
end

function MirrorTimer:OnLoadSettings()
    if not self.sets.display then self.sets.display = {label = true, time = true, border = true} end

    self:SetProperty("font", self:GetFontID())
    self:SetProperty("texture", self:GetTextureID())
end

---@return table defaults
function MirrorTimer:GetDefaults()
    return {
        point = "TOP",
        x = 0,
        y = -96 - ((tonumber(strmatch(self.id, "%d")) - 1) * 22),
        padW = 1,
        padH = 1,
        font = LSM:GetDefault(LSM.MediaType.FONT),
        texture = LSM:GetDefault(LSM.MediaType.STATUSBAR),
        display = {label = true, time = true, border = true},
    }
end

---@param event string
function MirrorTimer:OnEvent(event, ...)
    local func = self[event]
    if func then func(self, ...) end
end

function MirrorTimer:RegisterEvents()
    self:RegisterEvent("MIRROR_TIMER_PAUSE")
    self:RegisterEvent("MIRROR_TIMER_STOP")

    LSM.RegisterCallback(self, "LibSharedMedia_Registered")
end

---@param timerName string
---@param paused number
function MirrorTimer:MIRROR_TIMER_PAUSE(timerName, paused) if self.timer == timerName then self.paused = paused > 0 end end

---@param timerName string
function MirrorTimer:MIRROR_TIMER_STOP(timerName) if self.timer == timerName then self:Reset() end end

function MirrorTimer:LibSharedMedia_Registered(event, mediaType, key)
    if mediaType == LSM.MediaType.FONT and key == self:GetFontID() then
        self:font_update(key)
    elseif mediaType == LSM.MediaType.STATUSBAR and key == self:GetTextureID() then
        self:texture_update(key)
    end
end

---@param fontID any
function MirrorTimer:font_update(fontID)
    self.sets.font = fontID

    local newFont = LSM:Fetch(LSM.MediaType.FONT, fontID)
    local oldFont, fontSize, fontFlags = self.labelText:GetFont()

    if newFont and newFont ~= oldFont then
        self.labelText:SetFont(newFont, fontSize, fontFlags)
        self.timeText:SetFont(newFont, fontSize, fontFlags)
    end
end

---@param textureID any
function MirrorTimer:texture_update(textureID)
    local texture = LSM:Fetch(LSM.MediaType.STATUSBAR, self:GetTextureID())

    self.statusBar:SetStatusBarTexture(texture)
    self.bg:SetTexture(texture)
end

---@param key string
---@param value any
function MirrorTimer:SetProperty(key, value)
    local prev = self.props[key]

    if prev ~= value then
        self.props[key] = value

        local func = self[key .. "_update"]
        if func then func(self, value, prev) end
    end
end

---@param key string
---@return any value
function MirrorTimer:GetProperty(key) return self.props[key] end

function MirrorTimer:Layout()
    local padding = self:GetPadding()
    local width, height = self:GetDesiredWidth(), self:GetDesiredHeight()
    local displayingLabel = self:Displaying("label")
    local displayingTime = self:Displaying("time")
    local displayingBorder = self:Displaying("border")

    local border = self.border
    local bg = self.bg
    local sb = self.statusBar
    local time = self.timeText
    local label = self.labelText
    local insets = border:GetBackdrop().insets.left / 2

    self:TrySetSize(width, height)

    if displayingBorder then
        border:SetPoint("TOPLEFT", padding - insets, -(padding - insets))
        border:SetPoint("BOTTOMRIGHT", -(padding - insets), padding - insets)
        border:Show()

        padding = padding + insets / 2

        bg:SetPoint("TOPLEFT", padding, -padding)
        bg:SetPoint("BOTTOMRIGHT", -padding, padding)
    else
        border:Hide()

        bg:SetPoint("TOPLEFT")
        bg:SetPoint("BOTTOMRIGHT")
    end

    local widgetSize = height - padding * 2

    sb:SetPoint("LEFT", padding, 0)
    sb:SetPoint("RIGHT", -padding, 0)
    sb:SetHeight(widgetSize)

    local textoffset = 2 + (displayingBorder and insets or 0)

    label:SetPoint("LEFT", textoffset, 0)
    label:SetAlpha(displayingLabel and 1 or 0)

    if displayingTime then
        time:SetPoint("RIGHT", -textoffset, 0)
        time:SetAlpha(1)

        label:SetPoint("RIGHT", time, "LEFT", -textoffset, 0)
    else
        time:SetAlpha(0)

        label:SetPoint("RIGHT", -textoffset, 0)
    end

    if displayingTime then
        label:SetJustifyH("LEFT")
    else
        label:SetJustifyH("CENTER")
    end

    return self
end

---@param width number
function MirrorTimer:SetDesiredWidth(width)
    self.sets.w = tonumber(width)
    self:Layout()
end

---@return number width
function MirrorTimer:GetDesiredWidth() return self.sets.w or 200 end

---@param height number
function MirrorTimer:SetDesiredHeight(height)
    self.sets.h = tonumber(height)
    self:Layout()
end

---@return number height
function MirrorTimer:GetDesiredHeight() return self.sets.h or 20 end

---@param fontID any
function MirrorTimer:SetFontID(fontID)
    self.sets.font = fontID
    self:SetProperty("font", self:GetFontID())

    return self
end

---@return any fontID
function MirrorTimer:GetFontID() return self.sets.font or LSM:GetDefault(LSM.MediaType.FONT) end

---@param textureID any
function MirrorTimer:SetTextureID(textureID)
    self.sets.texture = textureID
    self:SetProperty("texture", self:GetTextureID())

    return self
end

---@return any textureID
function MirrorTimer:GetTextureID() return self.sets.texture or LSM:GetDefault(LSM.MediaType.STATUSBAR) end

---@param part string
---@param enable boolean
function MirrorTimer:SetDisplay(part, enable)
    self.sets.display[part] = enable
    self:Layout()
end

---@param part string
---@return boolean enabled
function MirrorTimer:Displaying(part) return self.sets.display[part] end

local MirrorTimerColors = MirrorTimerColors
---@param timer string
---@param value number
---@param maxValue number
---@param scale number
---@param paused number
---@param timerLabel string
function MirrorTimer:Start(timer, value, maxValue, scale, paused, timerLabel)
    self.timer = timer
    self.value = value * 0.001
    self.scale = scale
    self.paused = paused > 0

    self.labelText:SetText(timerLabel)

    local statusBar = self.statusBar
    statusBar:SetMinMaxValues(0, maxValue * 0.001)
    statusBar:SetValue(self.value)
    local color = MirrorTimerColors[timer]
    statusBar:SetStatusBarColor(color.r, color.g, color.b)

    self.container:Show()
    self:SetScript("OnUpdate", self.OnUpdate)
end

function MirrorTimer:Reset()
    self.container:Hide()
    self.timer = nil
    self:SetScript("OnUpdate", nil)
end

---@param elapsed number
function MirrorTimer:OnUpdate(elapsed)
    if self.paused then return end

    self.statusBar:SetValue(GetMirrorTimerProgress(self.timer) * 0.001)
end

---@param value number
---@param isUserInput boolean
function MirrorTimer:OnValueChanged(value, isUserInput)
    self.timeText:SetFormattedText("%.1f", value)
    self.spark:SetValue(value)
end

do
    function MirrorTimer:CreateMenu()
        local menu = Dominos:NewMenu(self.id)

        self:AddLayoutPanel(menu)
        self:AddTexturePanel(menu)
        self:AddFontPanel(menu)

        self.menu = menu

        self.menu:HookScript("OnShow", function()
            self:Start("BREATH", random(20, 60) * 1000, 60000, -1, 0, BREATH_LABEL)

            self:SetScript("OnUpdate", function(_, elapsed)
                self.statusBar:SetValue(self.statusBar:GetValue() - (elapsed))
            end)
        end)

        self.menu:HookScript("OnHide", function()
            local timer, value, maxvalue, scale, paused, label = GetMirrorTimerInfo(tonumber(strmatch(self.id, "%d")))
            if timer ~= "UNKNOWN" then
                self:Start(timer, value, maxvalue, scale, paused, label)
            else
                self:Reset()
            end
        end)

        return menu
    end

    ---@param menu table
    function MirrorTimer:AddLayoutPanel(menu)
        local panel = menu:NewPanel(LibStub("AceLocale-3.0"):GetLocale("Dominos-Config").Layout)

        local l = LibStub("AceLocale-3.0"):GetLocale("Dominos-CastBar")

        for i, part in pairs({"label", "time", "border"}) do
            panel:NewCheckButton({
                name = l["Display_" .. part],
                get = function() return panel.owner:Displaying(part) end,
                set = function(_, enable) panel.owner:SetDisplay(part, enable) end,
            })
        end

        panel.widthSlider = panel:NewSlider({
            name = l.Width,
            min = 1,
            max = function() return math.ceil(_G.UIParent:GetWidth() / panel.owner:GetScale()) end,
            get = function() return panel.owner:GetDesiredWidth() end,
            set = function(_, value) panel.owner:SetDesiredWidth(value) end,
        })

        panel.heightSlider = panel:NewSlider({
            name = l.Height,
            min = 1,
            max = function() return math.ceil(_G.UIParent:GetHeight() / panel.owner:GetScale()) end,
            get = function() return panel.owner:GetDesiredHeight() end,
            set = function(_, value) panel.owner:SetDesiredHeight(value) end,
        })

        panel.paddingSlider = panel:NewPaddingSlider()
        panel.scaleSlider = panel:NewScaleSlider()
        panel.opacitySlider = panel:NewOpacitySlider()
        panel.fadeSlider = panel:NewFadeSlider()
    end

    ---@param menu table
    function MirrorTimer:AddFontPanel(menu)
        local l = LibStub("AceLocale-3.0"):GetLocale("Dominos-CastBar")
        local panel = menu:NewPanel(l.Font)

        panel.fontSelector = Dominos.Options.FontSelector:New(
                                 {
                parent = panel,
                get = function() return panel.owner:GetFontID() end,
                set = function(_, value) panel.owner:SetFontID(value) end,
            })
    end

    ---@param menu table
    function MirrorTimer:AddTexturePanel(menu)
        local l = LibStub("AceLocale-3.0"):GetLocale("Dominos-CastBar")
        local panel = menu:NewPanel(l.Texture)

        panel.textureSelector = Dominos.Options.TextureSelector:New(
                                    {
                parent = panel,
                get = function() return panel.owner:GetTextureID() end,
                set = function(_, value) panel.owner:SetTextureID(value) end,
            })
    end
end

--[[ exports ]] --

Addon.MirrorTimer = MirrorTimer
