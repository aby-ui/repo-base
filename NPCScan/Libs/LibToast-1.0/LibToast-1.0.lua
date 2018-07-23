-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
local _G = getfenv(0)

-- Functions
local error = _G.error
local pairs = _G.pairs

-- Libraries
local table = _G.table

-----------------------------------------------------------------------
-- Library namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local MAJOR = "LibToast-1.0"

_G.assert(LibStub, MAJOR .. " requires LibStub")

local MINOR = 15 -- Should be manually increased
local LibToast, previousMinorVersion = LibStub:NewLibrary(MAJOR, MINOR)

if not LibToast then
    return
end -- No upgrade needed

-----------------------------------------------------------------------
-- Migrations.
-----------------------------------------------------------------------
LibToast.active_toasts = LibToast.active_toasts or {}
LibToast.queued_toasts = LibToast.queued_toasts or {}
LibToast.templates = LibToast.templates or {}
LibToast.unique_templates = LibToast.unique_templates or {}

LibToast.button_heap = LibToast.button_heap or {}
LibToast.toast_heap = LibToast.toast_heap or {}

LibToast.addon_names = LibToast.addon_names or {}
LibToast.registered_sink = LibToast.registered_sink
LibToast.sink_icons = LibToast.sink_icons or {}
LibToast.sink_template = LibToast.sink_template or {} -- Cheating here, since users can only use strings.
LibToast.sink_titles = LibToast.sink_titles or {}

-----------------------------------------------------------------------
-- Variables.
-----------------------------------------------------------------------
local CurrentToast
local IsInternalCall
local CallingObject

-----------------------------------------------------------------------
-- Constants.
-----------------------------------------------------------------------
local ActiveToasts = LibToast.active_toasts
local QueuedToasts = LibToast.queued_toasts
local ToastHeap = LibToast.toast_heap
local ButtonHeap = LibToast.button_heap

local ToastProxy = {}

local METHOD_USAGE_FORMAT = MAJOR .. ":%s() - %s."

local MAX_ACTIVE_TOASTS = 10

local DEFAULT_FADE_HOLD_TIME = 5
local DEFAULT_FADE_IN_TIME = 0.5
local DEFAULT_FADE_OUT_TIME = 1.2
local DEFAULT_TOAST_WIDTH = 250
local DEFAULT_TOAST_HEIGHT = 50
local DEFAULT_GLOW_WIDTH = 252
local DEFAULT_GLOW_HEIGHT = 56
local DEFAULT_ICON_SIZE = 30
local DEFAULT_OS_SPAWN_POINT = _G.IsMacClient() and "TOPRIGHT" or "BOTTOMRIGHT"

local DEFAULT_TOAST_BACKDROP = {
    bgFile = [[Interface\FriendsFrame\UI-Toast-Background]],
    edgeFile = [[Interface\FriendsFrame\UI-Toast-Border]],
    tile = true,
    tileSize = 12,
    edgeSize = 12,
    insets = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5,
    },
}

local DEFAULT_BACKGROUND_COLORS = {
    r = 0,
    g = 0,
    b = 0,
}

local DEFAULT_TITLE_COLORS = {
    r = 0.510,
    g = 0.773,
    b = 1,
}

local DEFAULT_TEXT_COLORS = {
    r = 0.486,
    g = 0.518,
    b = 0.541
}

local TOAST_BUTTONS = {
    primary_button = true,
    secondary_button = true,
    tertiary_button = true,
}
local TOAST_BUTTON_HEIGHT = 18

local POINT_TRANSLATION = {
    CENTER = DEFAULT_OS_SPAWN_POINT,
    BOTTOM = "BOTTOMRIGHT",
    BOTTOMLEFT = "BOTTOMLEFT",
    BOTTOMRIGHT = "BOTTOMRIGHT",
    LEFT = "TOPLEFT",
    RIGHT = "TOPRIGHT",
    TOP = "TOPRIGHT",
    TOPLEFT = "TOPLEFT",
    TOPRIGHT = "TOPRIGHT",
}

local SIBLING_ANCHORS = {
    TOPRIGHT = "BOTTOMRIGHT",
    TOPLEFT = "BOTTOMLEFT",
    BOTTOMRIGHT = "TOPRIGHT",
    BOTTOMLEFT = "TOPLEFT",
}

local OFFSET_X = {
    TOPRIGHT = -20,
    TOPLEFT = 20,
    BOTTOMRIGHT = -20,
    BOTTOMLEFT = 20,
}

local OFFSET_Y = {
    TOPRIGHT = -30,
    TOPLEFT = -30,
    BOTTOMRIGHT = 30,
    BOTTOMLEFT = 30,
}

local SIBLING_OFFSET_Y = {
    TOPRIGHT = -10,
    TOPLEFT = -10,
    BOTTOMRIGHT = 10,
    BOTTOMLEFT = 10,
}

local L_TOAST = "Toast"
local L_TOAST_DESC = "Shows messages in a toast window."

local LOCALE = _G.GetLocale()

if LOCALE == "esMX" or LOCALE == "esES" then
    L_TOAST = "Información emergente"
    L_TOAST_DESC = "Muestra mensajes de información en una ventana emergente"
elseif LOCALE == "frFR" then
    L_TOAST_DESC = "Montrer les messages dans une fenêtre \"toast\"."
elseif LOCALE == "deDE" then
    L_TOAST_DESC = "Zeigt Nachrichten in einem Toast-Fenster"
elseif LOCALE == "itIT" then
    -- Nothing yet.
elseif LOCALE == "koKR" then
    -- Nothing yet.
elseif LOCALE == "ptBR" then
    L_TOAST = "Brinde"
    L_TOAST_DESC = "Mostrar mensagems em uma janela externa"
elseif LOCALE == "ruRU" then
    L_TOAST = "Всплывающее"
    L_TOAST_DESC = "Показывать сообщения во всплывающем окне"
elseif LOCALE == "zhCN" then
    L_TOAST = "弹出窗口"
    L_TOAST_DESC = "在弹出窗口显示信息。"
elseif LOCALE == "zhTW" then
    L_TOAST = "彈出視窗"
    L_TOAST_DESC = "在彈出視窗顯示訊息。"
end

-----------------------------------------------------------------------
-- Variables.
-----------------------------------------------------------------------
local QueuedAddOnName

-----------------------------------------------------------------------
-- Settings functions.
-----------------------------------------------------------------------
local function ToastSpawnPoint()
    return _G.Toaster and _G.Toaster:SpawnPoint() or DEFAULT_OS_SPAWN_POINT
end

local function ToastOffsetX()
    return (_G.Toaster and _G.Toaster.SpawnOffsetX) and _G.Toaster:SpawnOffsetX() or nil
end

local function ToastOffsetY()
    return (_G.Toaster and _G.Toaster.SpawnOffsetY) and _G.Toaster:SpawnOffsetY() or nil
end

local function ToastTitleColors(urgencyLevel)
    if _G.Toaster then
        return _G.Toaster:TitleColors(urgencyLevel)
    else
        return DEFAULT_TITLE_COLORS.r, DEFAULT_TITLE_COLORS.g, DEFAULT_TITLE_COLORS.b
    end
end

local function ToastTextColors(urgencyLevel)
    if _G.Toaster then
        return _G.Toaster:TextColors(urgencyLevel)
    else
        return DEFAULT_TEXT_COLORS.r, DEFAULT_TEXT_COLORS.g, DEFAULT_TEXT_COLORS.b
    end
end

local function ToastBackgroundColors(urgencyLevel)
    if _G.Toaster then
        return _G.Toaster:BackgroundColors(urgencyLevel)
    else
        return DEFAULT_BACKGROUND_COLORS.r, DEFAULT_BACKGROUND_COLORS.g, DEFAULT_BACKGROUND_COLORS.b
    end
end

local function ToastDuration(addonName)
    return _G.Toaster and _G.Toaster:Duration(addonName) or DEFAULT_FADE_HOLD_TIME
end

local function ToastOpacity(addonName)
    return _G.Toaster and _G.Toaster:Opacity(addonName) or 0.75
end

local function ToastHasFloatingIcon(addonName)
    return _G.Toaster and _G.Toaster:FloatingIcon(addonName)
end

local function ToastsAreSuppressed(addonName)
    return _G.Toaster and (_G.Toaster:HideToasts() or _G.Toaster:HideToastsFromSource(addonName))
end

local function ToastsAreMuted(addonName)
    return _G.Toaster and (_G.Toaster:MuteToasts() or _G.Toaster:MuteToastsFromSource(addonName))
end

-----------------------------------------------------------------------
-- Helper functions.
-----------------------------------------------------------------------
local function AnimationHideParent(animation)
    animation:GetParent():Hide()
end

local function GetEffectiveSpawnPoint(frame)
    local x, y = frame:GetCenter()
    if not x or not y then
        return DEFAULT_OS_SPAWN_POINT
    end

    local horizontalName = (x > _G.UIParent:GetWidth() * 2 / 3) and "RIGHT" or (x < _G.UIParent:GetWidth() / 3) and "LEFT" or ""
    local verticalName = (y > _G.UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
    return verticalName .. horizontalName
end

local function GetCallingObject()
    return CallingObject
end

local function StringValue(input)
    local inputType = _G.type(input)

    if inputType == "function" then
        local output = input()
        if _G.type(output) ~= "string" or output == "" then
            return
        end

        return output
    elseif inputType == "string" then
        return input
    end
end

if not LibToast.templates[LibToast.sink_template] then
    LibToast.templates[LibToast.sink_template] = function(toast, text, _, _, _, _, _, _, _, _, iconTexture)
        local callingObject = GetCallingObject()
        toast:SetTitle(StringValue(LibToast.sink_titles[callingObject]))
        toast:SetText(text)
        toast:SetIconTexture(iconTexture or StringValue(LibToast.sink_icons[callingObject]))
    end
end

local function _positionToastIcon(toast)
    toast.icon:ClearAllPoints()

    if ToastHasFloatingIcon(toast.addonName) then
        local lowercasedPointName = POINT_TRANSLATION[GetEffectiveSpawnPoint(toast)]:lower()

        if lowercasedPointName:find("right") then
            toast.icon:SetPoint("TOPRIGHT", toast, "TOPLEFT", -5, -10)
        elseif lowercasedPointName:find("left") then
            toast.icon:SetPoint("TOPLEFT", toast, "TOPRIGHT", 5, -10)
        end
    else
        toast.icon:SetPoint("TOPLEFT", toast, "TOPLEFT", 10, -10)
    end
end

local function _reclaimButton(button)
    button:Hide()
    button:ClearAllPoints()
    button:SetParent(nil)
    button:SetText(nil)
    table.insert(ButtonHeap, button)
end

local function _reclaimToast(toast)
    for buttonName in pairs(TOAST_BUTTONS) do
        local button = toast[buttonName]

        if button then
            toast[buttonName] = nil
            _reclaimButton(button)
        end
    end
    toast.is_persistent = nil
    toast.templateName = nil
    toast.payload = nil
    toast.sound_file = nil
    toast:Hide()

    table.insert(ToastHeap, toast)

    local removalIndex
    for index = 1, #ActiveToasts do
        if ActiveToasts[index] == toast then
            removalIndex = index
            break
        end
    end

    if removalIndex then
        table.remove(ActiveToasts, removalIndex):ClearAllPoints()
    end
    local spawnPoint = ToastSpawnPoint()
    local offsetX = ToastOffsetX() or OFFSET_X[spawnPoint]
    local offsetY = ToastOffsetY() or OFFSET_Y[spawnPoint]

    for index = 1, #ActiveToasts do
        local indexedToast = ActiveToasts[index]
        indexedToast:ClearAllPoints()

        _positionToastIcon(indexedToast)

        if index == 1 then
            indexedToast:SetPoint(spawnPoint, _G.UIParent, spawnPoint, offsetX, offsetY)
        else
            spawnPoint = POINT_TRANSLATION[GetEffectiveSpawnPoint(ActiveToasts[1])]
            indexedToast:SetPoint(spawnPoint, ActiveToasts[index - 1], SIBLING_ANCHORS[spawnPoint], 0, SIBLING_OFFSET_Y[spawnPoint])
        end
    end

    local toastData = table.remove(QueuedToasts, 1)
    if toastData and toastData.addonName and _G.type(toastData.template) == "string" and toastData.template ~= "" then
        QueuedAddOnName = toastData.addonName
        LibToast:Spawn(toastData.template, _G.unpack(toastData.payload))
    end
end

local function AnimationDismissToast(animation)
    _reclaimToast(animation.toast)
end

local function Focus_OnEnter(frame, motion)
    local toast = frame.toast
    toast.dismiss_button:Show()

    if not toast.is_persistent then
        toast.waitAndAnimateOut:Stop()
        toast.waitAndAnimateOut.animateOut:SetStartDelay(1)
    end
end

local function Focus_OnLeave(frame, motion)
    local toast = frame.toast

    if not toast.dismiss_button:IsMouseOver() then
        toast.dismiss_button:Hide()
    end

    if not toast.is_persistent then
        toast.waitAndAnimateOut:Play()
    end
end

local function _dismissToast(frame, button, down)
    _reclaimToast(frame:GetParent())
end

local function _acquireToast(addonName)
    local toast = table.remove(ToastHeap)

    if not toast then
        toast = _G.CreateFrame("Button", nil, _G.UIParent)
        toast:SetFrameStrata("DIALOG")
        toast:Hide()

        local icon = toast:CreateTexture(nil, "BORDER")
        icon:SetSize(DEFAULT_ICON_SIZE, DEFAULT_ICON_SIZE)
        toast.icon = icon

        local title = toast:CreateFontString(nil, "BORDER", "FriendsFont_Normal")
        title:SetJustifyH("LEFT")
        title:SetJustifyV("MIDDLE")
        title:SetWordWrap(true)
        title:SetPoint("TOPLEFT", toast, "TOPLEFT", 44, -10)
        title:SetPoint("RIGHT", toast, "RIGHT", -20, 10)
        toast.title = title

        local focus = _G.CreateFrame("Frame", nil, toast)
        focus:SetAllPoints(toast)
        focus:SetScript("OnEnter", Focus_OnEnter)
        focus:SetScript("OnLeave", Focus_OnLeave)
        focus:SetScript("OnShow", Focus_OnLeave)
        focus.toast = toast

        local dismissButton = _G.CreateFrame("Button", nil, toast)
        dismissButton:SetSize(18, 18)
        dismissButton:SetPoint("TOPRIGHT", toast, "TOPRIGHT", -4, -4)
        dismissButton:SetFrameStrata("DIALOG")
        dismissButton:SetFrameLevel(toast:GetFrameLevel() + 2)
        dismissButton:SetNormalTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Up]])
        dismissButton:SetPushedTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Down]])
        dismissButton:SetHighlightTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Highlight]])
        dismissButton:Hide()
        dismissButton:SetScript("OnClick", _dismissToast)

        toast.dismiss_button = dismissButton

        local text = toast:CreateFontString(nil, "BORDER", "FriendsFont_Normal")
        text:SetJustifyH("LEFT")
        text:SetJustifyV("MIDDLE")
        text:SetWordWrap(true)
        text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
        toast.text = text

        local toastAnimateIn = toast:CreateAnimationGroup()
        toast.animateIn = toastAnimateIn

        local toastAnimateInFirst = toastAnimateIn:CreateAnimation("Alpha")
        toastAnimateInFirst:SetOrder(1)
        toastAnimateInFirst:SetFromAlpha(1)
        toastAnimateInFirst:SetToAlpha(0)
        toastAnimateInFirst:SetDuration(0)

        local toastAnimateInSecond = toastAnimateIn:CreateAnimation("Alpha")
        toastAnimateInSecond:SetOrder(2)
        toastAnimateInSecond:SetFromAlpha(0)
        toastAnimateInSecond:SetToAlpha(1)
        toastAnimateInSecond:SetDuration(0.2)

        local toastWaitAndAnimateOut = toast:CreateAnimationGroup()
        toast.waitAndAnimateOut = toastWaitAndAnimateOut

        local toastAnimateOut = toastWaitAndAnimateOut:CreateAnimation("Alpha")
        toastAnimateOut:SetStartDelay(DEFAULT_FADE_HOLD_TIME)
        toastAnimateOut:SetFromAlpha(1)
        toastAnimateOut:SetToAlpha(0)
        toastAnimateOut:SetDuration(DEFAULT_FADE_OUT_TIME)
        toastAnimateOut:SetScript("OnFinished", AnimationDismissToast)

        toastAnimateOut.toast = toast
        toastWaitAndAnimateOut.animateOut = toastAnimateOut

        local glowFrame = _G.CreateFrame("Frame", nil, toast)
        glowFrame:SetAllPoints(toast)
        toast.glowFrame = glowFrame

        local glowTexture = glowFrame:CreateTexture(nil, "OVERLAY")
        glowTexture:SetSize(DEFAULT_GLOW_WIDTH, DEFAULT_GLOW_HEIGHT)
        glowTexture:SetPoint("TOPLEFT", -1, 3)
        glowTexture:SetPoint("BOTTOMRIGHT", 1, -3)
        glowTexture:SetTexture([[Interface\FriendsFrame\UI-Toast-Flair]])
        glowTexture:SetBlendMode("ADD")
        glowTexture:Hide()

        glowFrame.glow = glowTexture

        local glowAnimateIn = glowTexture:CreateAnimationGroup()
        glowAnimateIn:SetScript("OnFinished", AnimationHideParent)
        glowTexture.animateIn = glowAnimateIn

        local glowAnimateInFirst = glowAnimateIn:CreateAnimation("Alpha")
        glowAnimateInFirst:SetOrder(1)
        glowAnimateInFirst:SetFromAlpha(0)
        glowAnimateInFirst:SetToAlpha(1)
        glowAnimateInFirst:SetDuration(0.2)

        local glowAnimateInSecond = glowAnimateIn:CreateAnimation("Alpha")
        glowAnimateInSecond:SetOrder(2)
        glowAnimateInSecond:SetFromAlpha(1)
        glowAnimateInSecond:SetToAlpha(0)
        glowAnimateInSecond:SetDuration(0.5)
    end

    toast:SetSize(DEFAULT_TOAST_WIDTH, DEFAULT_TOAST_HEIGHT)
    toast:SetBackdrop(DEFAULT_TOAST_BACKDROP)
    toast:SetBackdropBorderColor(1, 1, 1)

    if _G.Toaster then
        local iconSize = _G.Toaster:IconSize(addonName)
        toast.icon:SetSize(iconSize, iconSize)
    end

    return toast
end

-----------------------------------------------------------------------
-- Library methods.
-----------------------------------------------------------------------
function LibToast:Register(templateName, constructor, isUnique)
    local isLib = (self == LibToast)

    if _G.type(templateName) ~= "string" or templateName == "" then
        error(METHOD_USAGE_FORMAT:format(isLib and "Register" or "RegisterToast", "templateName must be a non-empty string"), 2)
    end

    if _G.type(constructor) ~= "function" then
        error(METHOD_USAGE_FORMAT:format(isLib and "Register" or "RegisterToast", "constructor must be a function"), 2)
    end

    LibToast.templates[templateName] = constructor
    LibToast.unique_templates[templateName] = isUnique or nil
end

function LibToast:Spawn(templateName, ...)
    local isLib = (self == LibToast)

    if not templateName or (not IsInternalCall and (_G.type(templateName) ~= "string" or templateName == "")) then
        error(METHOD_USAGE_FORMAT:format(isLib and "Spawn" or "SpawnToast", "templateName must be a non-empty string"), 2)
    end

    if not LibToast.templates[templateName] then
        error(METHOD_USAGE_FORMAT:format(isLib and "Spawn" or "SpawnToast", ("\"%s\" does not match a registered template"):format(templateName)), 2)
    end

    local addonName
    if QueuedAddOnName then
        addonName = QueuedAddOnName
        QueuedAddOnName = nil
    elseif isLib then
        addonName = _G.select(3, ([[\]]):split(_G.debugstack(2)))
    else
        addonName = LibToast.addon_names[self] or _G.UNKNOWN
    end

    if ToastsAreSuppressed(addonName) then
        return
    end

    if LibToast.unique_templates[templateName] then
        for index = 1, #ActiveToasts do
            if ActiveToasts[index].templateName == templateName then
                return
            end
        end
    end

    if #ActiveToasts >= MAX_ACTIVE_TOASTS then
        table.insert(QueuedToasts, {
            addonName = addonName,
            template = templateName,
            payload = { ... }
        })
        return
    end

    CurrentToast = _acquireToast(addonName)
    CurrentToast.templateName = templateName
    CurrentToast.addonName = addonName

    -----------------------------------------------------------------------
    -- Reset defaults.
    -----------------------------------------------------------------------
    CurrentToast.title:SetText(nil)
    CurrentToast.text:SetText(nil)
    CurrentToast.icon:SetTexture(nil)
    CurrentToast.icon:SetTexCoord(0, 1, 0, 1)

    -----------------------------------------------------------------------
    -- Run constructor.
    -----------------------------------------------------------------------
    CallingObject = self
    LibToast.templates[templateName](ToastProxy, ...)

    if not CurrentToast.title:GetText() and not CurrentToast.text:GetText() and not CurrentToast.icon:GetTexture() then
        _reclaimToast(CurrentToast)
        return
    end

    -----------------------------------------------------------------------
    -- Finalize layout.
    -----------------------------------------------------------------------
    local urgency = CurrentToast.urgency_level
    CurrentToast.title:SetTextColor(ToastTitleColors(urgency))
    CurrentToast.text:SetTextColor(ToastTextColors(urgency))

    local opacity = ToastOpacity(addonName)
    local r, g, b = ToastBackgroundColors(urgency)
    CurrentToast:SetBackdropColor(r, g, b, opacity)

    r, g, b = CurrentToast:GetBackdropBorderColor()
    CurrentToast:SetBackdropBorderColor(r, g, b, opacity)

    if ToastHasFloatingIcon(addonName) or not CurrentToast.icon:GetTexture() then
        CurrentToast.title:SetPoint("TOPLEFT", CurrentToast, "TOPLEFT", 10, -10)
    else
        CurrentToast.title:SetPoint("TOPLEFT", CurrentToast, "TOPLEFT", CurrentToast.icon:GetWidth() + 15, -10)
    end

    if CurrentToast.title:GetText() then
        CurrentToast.title:SetWidth(CurrentToast:GetWidth() - CurrentToast.icon:GetWidth() - 20)
        CurrentToast.title:Show()
    else
        CurrentToast.title:Hide()
    end

    if CurrentToast.text:GetText() then
        CurrentToast.text:SetWidth(CurrentToast:GetWidth() - CurrentToast.icon:GetWidth() - 20)
        CurrentToast.text:Show()
    else
        CurrentToast.text:Hide()
    end
    local buttonHeight = (CurrentToast.primary_button or CurrentToast.secondary_button or CurrentToast.tertiary_button) and TOAST_BUTTON_HEIGHT or 0
    CurrentToast:SetHeight(CurrentToast.text:GetStringHeight() + CurrentToast.title:GetStringHeight() + buttonHeight + 25)

    -----------------------------------------------------------------------
    -- Anchor and spawn.
    -----------------------------------------------------------------------
    local spawnPoint = ToastSpawnPoint()
    local offsetX = ToastOffsetX() or OFFSET_X[spawnPoint]
    local offsetY = ToastOffsetY() or OFFSET_Y[spawnPoint]

    if #ActiveToasts > 0 then
        spawnPoint = POINT_TRANSLATION[GetEffectiveSpawnPoint(ActiveToasts[1])]
        CurrentToast:SetPoint(spawnPoint, ActiveToasts[#ActiveToasts], SIBLING_ANCHORS[spawnPoint], 0, SIBLING_OFFSET_Y[spawnPoint])
    else
        CurrentToast:SetPoint(spawnPoint, _G.UIParent, spawnPoint, offsetX, offsetY)
    end

    ActiveToasts[#ActiveToasts + 1] = CurrentToast

    _positionToastIcon(CurrentToast)

    if CurrentToast.sound_file and not ToastsAreMuted(addonName) then
        _G.PlaySoundFile(CurrentToast.sound_file)
    end

    CurrentToast:Show()
    CurrentToast.animateIn:Play()
    CurrentToast.glowFrame.glow:Show()
    CurrentToast.glowFrame.glow.animateIn:Play()
    CurrentToast.waitAndAnimateOut:Stop() -- Stop prior fade attempt.

    if not CurrentToast.is_persistent then
        if CurrentToast:IsMouseOver() then
            CurrentToast.waitAndAnimateOut.animateOut:SetStartDelay(1)
        else
            CurrentToast.waitAndAnimateOut.animateOut:SetStartDelay(ToastDuration(addonName))
            CurrentToast.waitAndAnimateOut:Play()
        end
    end
end

function LibToast:DefineSink(displayName, texturePath)
    local isLib = (self == LibToast)
    local texturePathType = _G.type(texturePath)
    local displayNameType = _G.type(displayName)

    if texturePath and (texturePathType ~= "function" and (texturePathType ~= "string" or texturePath == "")) then
        error(METHOD_USAGE_FORMAT:format(isLib and "DefineSink" or "DefineSinkToast", "texturePath must be a non-empty string, a function that returns one, or nil"), 2)
    end
    if displayName and (displayNameType ~= "function" and (displayNameType ~= "string" or displayName == "")) then
        error(METHOD_USAGE_FORMAT:format(isLib and "DefineSink" or "DefineSinkToast", "displayName must be a non-empty string, a function that returns one, or nil"), 2)
    end

    local addonName = _G.select(3, ([[\]]):split(_G.debugstack(2)))
    LibToast.addon_names[self] = addonName or _G.UNKNOWN
    LibToast.sink_icons[self] = texturePath
    LibToast.sink_titles[self] = displayName

    if not LibToast.registered_sink then
        local LibSink = LibStub("LibSink-2.0")
        if not LibSink then
            return
        end

        LibSink:RegisterSink("LibToast-1.0", L_TOAST, L_TOAST_DESC, function(caller, text, ...)
            IsInternalCall = true

            local func
            if caller.SpawnToast then
                func = caller.SpawnToast
            else
                caller = LibToast
                func = LibToast.Spawn
            end

            func(caller, LibToast.sink_template, text, ...)
            IsInternalCall = nil
        end)

        LibToast.registered_sink = true
    end
end

-----------------------------------------------------------------------
-- Proxy methods.
-----------------------------------------------------------------------
local TOAST_URGENCIES = {
    very_low = true,
    moderate = true,
    normal = true,
    high = true,
    emergency = true,
}

function ToastProxy:SetUrgencyLevel(urgencyLevel)
    urgencyLevel = urgencyLevel:gsub(" ", "_"):lower()

    if not TOAST_URGENCIES[urgencyLevel] then
        error(("\"%s\" is not a valid toast urgency level"):format(urgencyLevel), 2)
    end
    CurrentToast.urgency_level = urgencyLevel
end

function ToastProxy:UrgencyLevel()
    return CurrentToast.urgency_level
end

function ToastProxy:SetTitle(title)
    CurrentToast.title:SetText(title)
end

function ToastProxy:SetFormattedTitle(title, ...)
    CurrentToast.title:SetFormattedText(title, ...)
end

function ToastProxy:SetText(text)
    CurrentToast.text:SetText(text)
end

function ToastProxy:SetFormattedText(text, ...)
    CurrentToast.text:SetFormattedText(text, ...)
end

function ToastProxy:SetIconAtlas(...)
    CurrentToast.icon:SetAtlas(...)
end

function ToastProxy:SetIconTexture(texture)
    CurrentToast.icon:SetTexture(texture)
end

function ToastProxy:SetIconTexCoord(...)
    CurrentToast.icon:SetTexCoord(...)
end

local _initializedToastButton
do
    local BUTTON_NAME_FORMAT = "LibToast_Button%d"
    local button_count = 0

    local function _buttonCallbackHandler(button, mouseButtonName, isPress)
        button.handler(button.id, mouseButtonName, isPress, button.toast.payload)
        _reclaimToast(button.toast)
    end

    local function _acquireToastButton(toast)
        local button = table.remove(ButtonHeap)

        if not button then
            button_count = button_count + 1

            button = _G.CreateFrame("Button", BUTTON_NAME_FORMAT:format(button_count), toast, "UIMenuButtonStretchTemplate")
            button:SetHeight(TOAST_BUTTON_HEIGHT)
            button:SetFrameStrata("DIALOG")
            button:SetScript("OnClick", _buttonCallbackHandler)

            local fontString = button:GetFontString()
            fontString:SetJustifyH("CENTER")
            fontString:SetJustifyV("CENTER")
        end

        button:SetParent(toast)
        button:SetFrameLevel(toast:GetFrameLevel() + 2)
        return button
    end

    function _initializedToastButton(buttonID, label, handler)
        if not label or not handler then
            error("label and handler are required", 3)
            return
        end

        local button = CurrentToast[buttonID]
        if not button then
            button = _acquireToastButton(CurrentToast)
            CurrentToast[buttonID] = button
        end

        button.id = buttonID:gsub("_button", "")
        button.handler = handler
        button.toast = CurrentToast

        button:Show()
        button:SetText(label)
        button:SetWidth(button:GetFontString():GetStringWidth() + 15)

        return button
    end
end -- do-block

function ToastProxy:SetPrimaryCallback(label, handler)
    local button = _initializedToastButton("primary_button", label, handler)
    button:SetPoint("BOTTOMLEFT", CurrentToast, "BOTTOMLEFT", 3, 4)
    button:SetPoint("BOTTOMRIGHT", CurrentToast, "BOTTOMRIGHT", -3, 4)

    CurrentToast:SetHeight(CurrentToast:GetHeight() + button:GetHeight() + 5)

    if button:GetWidth() > CurrentToast:GetWidth() then
        CurrentToast:SetWidth(button:GetWidth() + 5)
    end
end

function ToastProxy:SetSecondaryCallback(label, handler)
    if not CurrentToast.primary_button then
        error("primary button must be defined first", 2)
    end
    CurrentToast.primary_button:ClearAllPoints()
    CurrentToast.primary_button:SetPoint("BOTTOMLEFT", CurrentToast, "BOTTOMLEFT", 3, 4)

    local button = _initializedToastButton("secondary_button", label, handler)
    button:SetPoint("BOTTOMRIGHT", CurrentToast, "BOTTOMRIGHT", -3, 4)

    if button:GetWidth() + CurrentToast.primary_button:GetWidth() > CurrentToast:GetWidth() then
        CurrentToast:SetWidth(button:GetWidth() + CurrentToast.primary_button:GetWidth() + 5)
    end
end

function ToastProxy:SetTertiaryCallback(label, handler)
    if not CurrentToast.primary_button or not CurrentToast.secondary_button then
        error("primary and secondary buttons must be defined first", 2)
    end
    CurrentToast.secondary_button:ClearAllPoints()
    CurrentToast.secondary_button:SetPoint("LEFT", CurrentToast.primary_button, "RIGHT", 0, 0)

    local button = _initializedToastButton("tertiary_button", label, handler)
    button:SetPoint("LEFT", CurrentToast.secondary_button, "RIGHT", 0, 0)

    if button:GetWidth() + CurrentToast.primary_button:GetWidth() + CurrentToast.secondary_button:GetWidth() > CurrentToast:GetWidth() then
        CurrentToast:SetWidth(button:GetWidth() + CurrentToast.primary_button:GetWidth() + CurrentToast.secondary_button:GetWidth() + 5)
    end
end

function ToastProxy:SetPayload(...)
    CurrentToast.payload = { ... }
end

function ToastProxy:Payload()
    return _G.unpack(CurrentToast.payload)
end

function ToastProxy:MakePersistent()
    CurrentToast.is_persistent = true
end

function ToastProxy:SetSoundFile(filePath)
    CurrentToast.sound_file = filePath
end

-----------------------------------------------------------------------
-- Embed handling.
-----------------------------------------------------------------------
LibToast.embeds = LibToast.embeds or {}

local mixins = {
    "DefineSink",
    "Register",
    "Spawn",
}

function LibToast:Embed(target)
    LibToast.embeds[target] = true

    for index = 1, #mixins do
        local method = mixins[index]
        target[method .. "Toast"] = LibToast[method]
    end
    return target
end

for addon in pairs(LibToast.embeds) do
    LibToast:Embed(addon)
end
