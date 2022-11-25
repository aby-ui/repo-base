-----------------------------------------
-- LibWidgets
-- by KevinSK
-----------------------------------------
local addonName, addon = ...
local L = addon.L
local F = addon.funcs
local P = addon.pixelPerfectFuncs
local LCG = LibStub("LibCustomGlow-1.0")

-----------------------------------------
-- Color
-----------------------------------------
local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

local colors = {
    grey = {s="|cFFB2B2B2", t={0.7, 0.7, 0.7}},
    yellow = {s="|cFFFFD100", t= {1, 0.82, 0}},
    orange = {s="|cFFFFC0CB", t= {1, 0.65, 0}},
    firebrick = {s="|cFFFF3030", t={1, 0.19, 0.19}},
    skyblue = {s="|cFF00CCFF", t={0, 0.8, 1}},
    chartreuse = {s="|cFF80FF00", t={0.5, 1, 0}},
}

local class = select(2, UnitClass("player"))
local accentColor = {s="|cCCB2B2B2", t={0.7, 0.7, 0.7}}
if class then
    accentColor.t[1], accentColor.t[2], accentColor.t[3], accentColor.s = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b, RAID_CLASS_COLORS[class].colorStr
    accentColor.s = "|c"..accentColor.s
end

-----------------------------------------
-- Font
-----------------------------------------
-- local fonts = {}
-- local function SetFont(obj, font, size, flags)
--     -- store in fonts for resizing
--     tinsert(fonts, {
--         ["obj"] = obj,
--         ["font"] = font,
--         ["size"] = size,
--         ["flags"] = flags
--     })
--     obj:SetFont()
-- end

local font_title_name = strupper(addonName).."_FONT_WIDGET_TITLE"
local font_title_disable_name = strupper(addonName).."_FONT_WIDGET_TITLE_DISABLE"
local font_name = strupper(addonName).."_FONT_WIDGET"
local font_disable_name = strupper(addonName).."_FONT_WIDGET_DISABLE"
local font_special_name = strupper(addonName).."_FONT_SPECIAL"
local font_class_title_name = strupper(addonName).."_FONT_CLASS_TITLE"
local font_class_name = strupper(addonName).."_FONT_CLASS"

local font_title = CreateFont(font_title_name)
font_title:SetFont(GameFontNormal:GetFont(), 14, "")
font_title:SetTextColor(1, 1, 1, 1)
font_title:SetShadowColor(0, 0, 0)
font_title:SetShadowOffset(1, -1)
font_title:SetJustifyH("CENTER")

local font_title_disable = CreateFont(font_title_disable_name)
font_title_disable:SetFont(GameFontNormal:GetFont(), 14, "")
font_title_disable:SetTextColor(0.4, 0.4, 0.4, 1)
font_title_disable:SetShadowColor(0, 0, 0)
font_title_disable:SetShadowOffset(1, -1)
font_title_disable:SetJustifyH("CENTER")

local font = CreateFont(font_name)
font:SetFont(GameFontNormal:GetFont(), 13, "")
font:SetTextColor(1, 1, 1, 1)
font:SetShadowColor(0, 0, 0)
font:SetShadowOffset(1, -1)
font:SetJustifyH("CENTER")

local font_disable = CreateFont(font_disable_name)
font_disable:SetFont(GameFontNormal:GetFont(), 13, "")
font_disable:SetTextColor(0.4, 0.4, 0.4, 1)
font_disable:SetShadowColor(0, 0, 0)
font_disable:SetShadowOffset(1, -1)
font_disable:SetJustifyH("CENTER")

local font_special = CreateFont(font_special_name)
font_special:SetFont("Interface\\AddOns\\Cell\\Media\\font.ttf", 12, "")
font_special:SetTextColor(1, 1, 1, 1)
font_special:SetShadowColor(0, 0, 0)
font_special:SetShadowOffset(1, -1)
font_special:SetJustifyH("CENTER")
font_special:SetJustifyV("MIDDLE")

local font_class_title = CreateFont(font_class_title_name)
font_class_title:SetFont(GameFontNormal:GetFont(), 14, "")
font_class_title:SetTextColor(accentColor.t[1], accentColor.t[2], accentColor.t[3])
font_class_title:SetShadowColor(0, 0, 0)
font_class_title:SetShadowOffset(1, -1)
font_class_title:SetJustifyH("CENTER")

local font_class = CreateFont(font_class_name)
font_class:SetFont(GameFontNormal:GetFont(), 13, "")
font_class:SetTextColor(accentColor.t[1], accentColor.t[2], accentColor.t[3])
font_class:SetShadowColor(0, 0, 0)
font_class:SetShadowOffset(1, -1)
font_class:SetJustifyH("CENTER")

local defaultFont = GameFontNormal:GetFont()
local fontSizeOffset = 0
function addon:UpdateOptionsFont(offset, useGameFont)
    if useGameFont then
        defaultFont = GameFontNormal:GetFont()
    else
        defaultFont = "Interface\\AddOns\\Cell\\Media\\Accidental_Presidency.ttf"
    end
    fontSizeOffset = offset

    font_title:SetFont(defaultFont, 14+offset, "")
    font_title_disable:SetFont(defaultFont, 14+offset, "")
    font:SetFont(defaultFont, 13+offset, "")
    font_disable:SetFont(defaultFont, 13+offset, "")
    font_class_title:SetFont(defaultFont, 14+offset, "")
    font_class:SetFont(defaultFont, 13+offset, "")
end

-----------------------------------------
-- Accent Color
-----------------------------------------
local accentColorOverride
function addon:OverrideAccentColor(cTable)
    accentColorOverride = true

    accentColor.t[1], accentColor.t[2], accentColor.t[3] = unpack(cTable)
    accentColor.s = "|cFF"..F:ConvertRGBToHEX(F:ConvertRGB_256(unpack(cTable)))
    
    font_class_title:SetTextColor(unpack(cTable))
    font_class:SetTextColor(unpack(cTable))
end

function addon:GetAccentColorRGB()
    return unpack(accentColor.t)
end

function addon:GetAccentColorTable(alpha)
    if alpha then
        return {accentColor.t[1], accentColor.t[2], accentColor.t[3], alpha}
    else
        return accentColor.t
    end
end

function addon:GetAccentColorString()
    return accentColor.s
end

function addon:ColorFontStringWithAccentColor(fs)
    fs:SetTextColor(accentColor.t[1], accentColor.t[2], accentColor.t[3])
end

function addon:WrapTextInAccentColor(text)
    return WrapTextInColorCode(text, accentColor.s)
end

-----------------------------------------
-- enable/disable
-----------------------------------------
function addon:SetEnabled(isEnabled, ...)
    for _, w in pairs({...}) do
        if w:IsObjectType("FontString") then
            if isEnabled then
                w:SetTextColor(1, 1, 1, 1)
            else
                w:SetTextColor(0.4, 0.4, 0.4, 1)
            end   
        elseif w:IsObjectType("Texture") then   
            if isEnabled then
                w:SetDesaturated(false)
            else
                w:SetDesaturated(true)
            end      
        else
            w:SetEnabled(isEnabled)
        end
    end
end

-----------------------------------------
-- rainbow text
-----------------------------------------
local colorSelect = CreateFrame("Colorselect")
function addon:StartRainbowText(fs, reverse)
    -- save original
    fs.text = fs:GetText()
    
    -- updater
    fs.rainbow = true
    if not fs.updater then
        fs.updater = CreateFrame("Frame", nil, fs:GetParent())
    end
    
    local pos = 0
    local step = 360 / (#fs.text-1)
    local col
    local str
    
    fs.updater:SetScript("OnUpdate", function(self, elapsed)
        
        local hue = pos
        -- NOTE: lua 正则匹配中文，不知道会不会有问题
        str = fs.text:gsub("[%z\1-\127\194-\244][\128-\191]*", function(char)
            colorSelect:SetColorHSV(hue,1,1)
            col = CreateColor(colorSelect:GetColorRGB())
            hue = (hue+step) > 360 and (hue+step)-360 or hue+step
            return col:WrapTextInColorCode(char)
        end)

        if reverse then
            pos = (pos+1) > 360 and 0 or pos + 1
        else
            pos = (pos-1) < 0 and 360 or pos - 1
        end
    
        fs:SetText(str)
    end)
end

function addon:StopRainbowText(fs)
    fs.rainbow = nil
    if fs.updater then
        fs.updater:SetScript("OnUpdate", nil)
        fs:SetText(fs.text)
    end
end

-----------------------------------------
-- seperator
-----------------------------------------
function addon:CreateSeparator(text, parent, width, color)
    if not color then color = {t={accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.777}, s=accentColor.s} end
    if not width then width = parent:GetWidth()-10 end

    local fs = parent:CreateFontString(nil, "OVERLAY", font_title_name)
    fs:SetJustifyH("LEFT")
    fs:SetTextColor(color.t[1], color.t[2], color.t[3])
    fs:SetText(text)

    local line = parent:CreateTexture()
    P:Size(line, width, 1)
    line:SetColorTexture(unpack(color.t))
    P:Point(line, "TOPLEFT", fs, "BOTTOMLEFT", 0, -2)
    local shadow = parent:CreateTexture()
    P:Size(shadow, width, 1)
    shadow:SetColorTexture(0, 0, 0, 1)
    P:Point(shadow, "TOPLEFT", line, "TOPLEFT", 1, -1)

    return fs
end

function addon:CreateTitledPane(parent, text, width, height, color)
    if not color then color = {["r"]=accentColor.t[1], ["g"]=accentColor.t[2], ["b"]=accentColor.t[3], ["a"]=0.777, ["s"]=accentColor.s} end

    local pane = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    P:Size(pane, width, height)
    -- addon:StylizeFrame(pane, {0,1,0,0.1}, {0,0,0,0})

    -- underline
    local line = pane:CreateTexture()
    pane.line = line
    P:Height(line, 1)
    line:SetColorTexture(color.r, color.g, color.b, color.a)
    line:SetPoint("TOPLEFT", pane, "TOPLEFT", 0, P:Scale(-17))
    line:SetPoint("TOPRIGHT", pane, "TOPRIGHT", 0, P:Scale(-17))

    local shadow = pane:CreateTexture()
    P:Height(shadow, 1)
    shadow:SetColorTexture(0, 0, 0, 1)
    shadow:SetPoint("TOPLEFT", line, "TOPLEFT", P:Scale(1), P:Scale(-1))
    shadow:SetPoint("TOPRIGHT", line, "TOPRIGHT", P:Scale(1), P:Scale(-1))

    -- title
    local title = pane:CreateFontString(nil, "OVERLAY", font_title_name)
    pane.title = title
    title:SetJustifyH("LEFT")
    title:SetTextColor(color.r, color.g, color.b)
    title:SetText(text)
    title:SetPoint("BOTTOMLEFT", line, "TOPLEFT", 0, P:Scale(2))

    -- func
    function pane:SetTitle(t)
        title:SetText(t)
    end

    return pane
end

-----------------------------------------
-- Frame
-----------------------------------------
function addon:StylizeFrame(frame, color, borderColor)
    if not color then color = {0.1, 0.1, 0.1, 0.9} end
    if not borderColor then borderColor = {0, 0, 0, 1} end

    frame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    frame:SetBackdropColor(unpack(color))
    frame:SetBackdropBorderColor(unpack(borderColor))
end

function addon:CreateFrame(name, parent, width, height, isTransparent)
    local f = CreateFrame("Frame", name, parent, "BackdropTemplate")
    f:Hide()
    if not isTransparent then addon:StylizeFrame(f) end
    f:EnableMouse(true)
    if width and height then P:Size(f, width, height) end

    function f:UpdatePixelPerfect()
        if not isTransparent then addon:StylizeFrame(f) end
        if width and height then
            P:Resize(f)
        end
    end

    return f
end


function addon:CreateMovableFrame(title, name, width, height, frameStrata, frameLevel, notUserPlaced)
    local f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    f:EnableMouse(true)
    f:SetIgnoreParentScale(true)
    -- f:SetResizable(false)
    f:SetMovable(true)
    f:SetUserPlaced(not notUserPlaced)
    f:SetFrameStrata(frameStrata or "HIGH")
    f:SetFrameLevel(frameLevel or 1)
    f:SetClampedToScreen(true)
    f:SetClampRectInsets(0, 0, P:Scale(20), 0)
    P:Size(f, width, height)
    f:SetPoint("CENTER")
    f:Hide()
    addon:StylizeFrame(f)
    
    -- header
    local header = CreateFrame("Frame", nil, f, "BackdropTemplate")
    f.header = header
    header:EnableMouse(true)
    header:SetClampedToScreen(true)
    header:RegisterForDrag("LeftButton")
    header:SetScript("OnDragStart", function()
        f:StartMoving()
        if notUserPlaced then f:SetUserPlaced(false) end
    end)
    header:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
    header:SetPoint("LEFT")
    header:SetPoint("RIGHT")
    header:SetPoint("BOTTOM", f, "TOP", 0, -1)
    P:Height(header, 20)
    addon:StylizeFrame(header, {0.115, 0.115, 0.115, 1})
    
    header.text = header:CreateFontString(nil, "OVERLAY", font_class_title_name)
    header.text:SetText(title)
    header.text:SetPoint("CENTER", header)
    
    header.closeBtn = addon:CreateButton(header, "×", "red", {20, 20}, false, false, "CELL_FONT_SPECIAL", "CELL_FONT_SPECIAL")
    header.closeBtn:SetPoint("TOPRIGHT")
    header.closeBtn:SetScript("OnClick", function() f:Hide() end)

    function f:UpdatePixelPerfect()
        f:SetClampRectInsets(0, 0, P:Scale(20), 0)
        P:Resize(f)
        addon:StylizeFrame(f)
        P:Resize(header, 20)
        P:Repoint(header)
        addon:StylizeFrame(header, {0.115, 0.115, 0.115, 1})
        P:Resize(header.closeBtn)
    end

    return f
end

-----------------------------------------
-- tooltip
-----------------------------------------
local function ShowTooltips(widget, anchor, x, y, tooltips)
    if type(tooltips) ~= "table" or #tooltips == 0 then
        CellTooltip:Hide()
        return
    end

    CellTooltip:SetOwner(widget, anchor or "ANCHOR_TOP", x or 0, y or 0)
    CellTooltip:AddLine(tooltips[1])
    for i = 2, #tooltips do
        if tooltips[i] then
            CellTooltip:AddLine("|cffffffff" .. tooltips[i])
        end
    end
    CellTooltip:Show()
end

function addon:SetTooltips(widget, anchor, x, y, ...)
    if not widget.tooltipsInited then
        widget._tooltipsInited = true

        widget:HookScript("OnEnter", function()
            ShowTooltips(widget, anchor, x, y, widget.tooltips)
        end)
        widget:HookScript("OnLeave", function()
            CellTooltip:Hide()
        end)
    end

    widget.tooltips = {...}
end

function addon:ClearTooltips(widget)
    widget.tooltips = nil
end

-----------------------------------------
-- change frame size with animation
-----------------------------------------
function addon:ChangeSizeWithAnimation(frame, targetWidth, targetHeight, step, startFunc, endFunc, repoint)
    if startFunc then startFunc() end
    
    local currentHeight = frame:GetHeight()
    local currentWidth = frame:GetWidth()
    targetWidth = targetWidth or currentWidth
    targetHeight = targetHeight or currentHeight

    step = step or 6
    local diffH = (targetHeight - currentHeight) / step
    local diffW = (targetWidth - currentWidth) / step
    
    local animationTimer
    animationTimer = C_Timer.NewTicker(0.025, function()
        if diffW ~= 0 then
            if diffW > 0 then
                currentWidth = math.min(currentWidth + diffW, targetWidth)
            else
                currentWidth = math.max(currentWidth + diffW, targetWidth)
            end
            P:Width(frame, currentWidth)
        end

        if diffH ~= 0 then
            if diffH > 0 then
                currentHeight = math.min(currentHeight + diffH, targetHeight)
            else
                currentHeight = math.max(currentHeight + diffH, targetHeight)
            end
            P:Height(frame, currentHeight)
        end

        if currentWidth == targetWidth and currentHeight == targetHeight then
            animationTimer:Cancel()
            animationTimer = nil
            if endFunc then endFunc() end
            if repoint then P:PixelPerfectPoint(frame) end -- already point to another frame
        end
    end)
end

-----------------------------------------
-- Button
-----------------------------------------
function addon:CreateButton(parent, text, buttonColor, size, noBorder, noBackground, fontNormal, fontDisable, template, ...)
    local b = CreateFrame("Button", nil, parent, template and template..",BackdropTemplate" or "BackdropTemplate")
    if parent then b:SetFrameLevel(parent:GetFrameLevel()+1) end
    b:SetText(text)
    P:Size(b, size[1], size[2])

    local color, hoverColor
    if buttonColor == "red" then
        color = {0.6, 0.1, 0.1, 0.6}
        hoverColor = {0.6, 0.1, 0.1, 1}
    elseif buttonColor == "red-hover" then
        color = {0.115, 0.115, 0.115, 1}
        hoverColor = {0.6, 0.1, 0.1, 1}
    elseif buttonColor == "green" then
        color = {0.1, 0.6, 0.1, 0.6}
        hoverColor = {0.1, 0.6, 0.1, 1}
    elseif buttonColor == "green-hover" then
        color = {0.115, 0.115, 0.115, 1}
        hoverColor = {0.1, 0.6, 0.1, 1}
    elseif buttonColor == "cyan" then
        color = {0, 0.9, 0.9, 0.6}
        hoverColor = {0, 0.9, 0.9, 1}
    elseif buttonColor == "blue" then
        color = {0, 0.5, 0.8, 0.6}
        hoverColor = {0, 0.5, 0.8, 1}
    elseif buttonColor == "blue-hover" then
        color = {0.115, 0.115, 0.115, 1}
        hoverColor = {0, 0.5, 0.8, 1}
    elseif buttonColor == "yellow" then
        color = {0.7, 0.7, 0, 0.6}
        hoverColor = {0.7, 0.7, 0, 1}
    elseif buttonColor == "yellow-hover" then
        color = {0.115, 0.115, 0.115, 1}
        hoverColor = {0.7, 0.7, 0, 1}
    elseif buttonColor == "accent" then
        if class == "PRIEST" and not accentColorOverride then
            color = {accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.25}
            hoverColor = {accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.5}
        else
            color = {accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.3}
            hoverColor = {accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.6}
        end
    elseif buttonColor == "accent-hover" then
        color = {0.115, 0.115, 0.115, 1}
        if class == "PRIEST" and not accentColorOverride then
            hoverColor = {accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.5}
        else
            hoverColor = {accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.6}
        end
    elseif buttonColor == "chartreuse" then
        color = {0.5, 1, 0, 0.6}
        hoverColor = {0.5, 1, 0, 0.8}
    elseif buttonColor == "magenta" then
        color = {0.6, 0.1, 0.6, 0.6}
        hoverColor = {0.6, 0.1, 0.6, 1}
    elseif buttonColor == "transparent" then -- drop down item
        color = {0, 0, 0, 0}
        hoverColor = {0.5, 1, 0, 0.7}
    elseif buttonColor == "transparent-white" then -- drop down item
        color = {0, 0, 0, 0}
        hoverColor = {0.4, 0.4, 0.4, 0.7}
    elseif buttonColor == "transparent-light" then -- drop down item
        color = {0, 0, 0, 0}
        hoverColor = {0.5, 1, 0, 0.5}
    elseif buttonColor == "transparent-accent" then -- drop down item
        color = {0, 0, 0, 0}
        if class == "PRIEST" and not accentColorOverride then
            hoverColor = {accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.4}
        else
            hoverColor = {accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.6}
        end
    elseif buttonColor == "none" then
        color = {0, 0, 0, 0}
    else
        color = {0.115, 0.115, 0.115, 0.7}
        hoverColor = {0.5, 1, 0, 0.6}
    end

    -- keep color & hoverColor
    b.color = color
    b.hoverColor = hoverColor

    local s = b:GetFontString()
    if s then
        s:SetWordWrap(false)
        -- s:SetWidth(size[1])
        s:SetPoint("LEFT")
        s:SetPoint("RIGHT")

        function b:SetTextColor(...)
            s:SetTextColor(...)
        end
    end
    
    if noBorder then
        b:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    else
        local n = P:Scale(1)
        b:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = n, insets = {left=n, right=n, top=n, bottom=n}})
    end
    
    if buttonColor and string.find(buttonColor, "transparent") then -- drop down item
        -- b:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
        if s then
            s:SetJustifyH("LEFT")
            s:SetPoint("LEFT", 5, 0)
            s:SetPoint("RIGHT", -5, 0)
        end
        b:SetBackdropBorderColor(1, 1, 1, 0)
        b:SetPushedTextOffset(0, 0)
    else
        if not noBackground then
            local bg = b:CreateTexture()
            bg:SetDrawLayer("BACKGROUND", -8)
            b.bg = bg
            bg:SetAllPoints(b)
            bg:SetColorTexture(0.115, 0.115, 0.115, 1)
        end

        b:SetBackdropBorderColor(0, 0, 0, 1)
        b:SetPushedTextOffset(0, -1)
    end


    b:SetBackdropColor(unpack(color)) 
    b:SetDisabledFontObject(fontDisable or font_disable)
    b:SetNormalFontObject(fontNormal or font)
    b:SetHighlightFontObject(fontNormal or font)
    
    if buttonColor ~= "none" then
        b:SetScript("OnEnter", function(self) self:SetBackdropColor(unpack(self.hoverColor)) end)
        b:SetScript("OnLeave", function(self) self:SetBackdropColor(unpack(self.color)) end)
    end

    -- click sound
    if Cell.isRetail then
        b:SetScript("PostClick", function(self, button, down)
            --! NOTE: ActionButtonUseKeyDown will affect OnClick
            if template and strfind(template, "Secure") then
                if down == GetCVarBool("ActionButtonUseKeyDown") then
                    PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
                end
            else
                PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
            end
        end)
    else
        b:SetScript("PostClick", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) end)
    end

    addon:SetTooltips(b, "ANCHOR_TOPLEFT", 0, 3, ...)

    -- texture
    function b:SetTexture(tex, texSize, point)
        b.tex = b:CreateTexture(nil, "ARTWORK")
        b.tex:SetPoint(unpack(point))
        b.tex:SetSize(unpack(texSize))
        b.tex:SetTexture(tex)
        -- update fontstring point
        if s then
            s:ClearAllPoints()
            s:SetPoint("LEFT", b.tex, "RIGHT", point[2], 0)
            s:SetPoint("RIGHT", -point[2], 0)
            b:SetPushedTextOffset(0, 0)
        end
        -- push effect
        b.onMouseDown = function()
            b.tex:ClearAllPoints()
            b.tex:SetPoint(point[1], point[2], point[3]-1)
        end
        b.onMouseUp = function()
            b.tex:ClearAllPoints()
            b.tex:SetPoint(unpack(point))
        end
        b:SetScript("OnMouseDown", b.onMouseDown)
        b:SetScript("OnMouseUp", b.onMouseUp)
        -- enable / disable
        b:HookScript("OnEnable", function()
            b.tex:SetVertexColor(1, 1, 1)
            b:SetScript("OnMouseDown", b.onMouseDown)
            b:SetScript("OnMouseUp", b.onMouseUp)
        end)
        b:HookScript("OnDisable", function()
            b.tex:SetVertexColor(0.4, 0.4, 0.4)
            b:SetScript("OnMouseDown", nil)
            b:SetScript("OnMouseUp", nil)
        end)
    end

    function b:UpdatePixelPerfect()
        P:Resize(b)
        P:Repoint(b)

        if not noBorder then
            -- backup colors
            local currentBackdropColor = {b:GetBackdropColor()}
            local currentBackdropBorderColor = {b:GetBackdropBorderColor()}
            -- update backdrop
            local n = P:Scale(1)
            b:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = n, insets = {left=n, right=n, top=n, bottom=n}})
            -- restore colors
            b:SetBackdropColor(unpack(currentBackdropColor))
            b:SetBackdropBorderColor(unpack(currentBackdropBorderColor))
            currentBackdropColor = nil
            currentBackdropBorderColor = nil
        end
    end

    return b
end

-----------------------------------------
-- Power Filter
-----------------------------------------
local function UpdateButtonSelection(b, selected)
    b.tex:SetDesaturated(not selected)
    -- if selected then
    --     b:SetBackdropColor(unpack(b.hoverColor))
    --     b:SetScript("OnEnter", nil)
    --     b:SetScript("OnLeave", nil)
    -- else
    --     b:SetBackdropColor(unpack(b.color))
    --     b:SetScript("OnEnter", function() 
    --         b:SetBackdropColor(unpack(b.hoverColor))
    --     end)
    --     b:SetScript("OnLeave", function() 
    --         b:SetBackdropColor(unpack(b.color))
    --     end)
    -- end
end

local localizedClass = {}
FillLocalizedClassList(localizedClass)

function addon:CreatePowerFilter(parent, classFileName, buttons, width, height, bWidth, color, bgColor)
    local filter = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    Cell:StylizeFrame(filter, color, bgColor)
    P:Size(filter, width, height)

    filter.text = filter:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    filter.text:SetPoint("LEFT", 5, 0)
    if classFileName == "VEHICLE" or classFileName == "PET" or classFileName == "NPC" then
        filter.text:SetText("|cff00ff33"..L[classFileName])
    else
        filter.text:SetText("|c"..RAID_CLASS_COLORS[classFileName].colorStr..localizedClass[classFileName])
    end
    -- filter:SetPoint("TOPLEFT", 5, -5)

    filter.buttons = {}
    local last
    for i = #buttons, 1, -1 do
        local b = Cell:CreateButton(filter, nil, "accent-hover", {height, height})
        filter.buttons[buttons[i]] = b
        b:SetTexture("Interface\\AddOns\\Cell\\Media\\Roles\\"..buttons[i], {height-4, height-4}, {"CENTER", 0, 0})

        if last then
            b:SetPoint("BOTTOMRIGHT", last, "BOTTOMLEFT", P:Scale(1), 0)
        else
            b:SetPoint("BOTTOMRIGHT", filter)
        end
        last = b

        b:SetScript("OnClick", function()
            local selected
            if type(filter.selectedLayoutTable["powerFilters"][classFileName]) == "boolean" then
                filter.selectedLayoutTable["powerFilters"][classFileName] = not filter.selectedLayoutTable["powerFilters"][classFileName]
                selected = filter.selectedLayoutTable["powerFilters"][classFileName]
            else
                filter.selectedLayoutTable["powerFilters"][classFileName][buttons[i]] = not filter.selectedLayoutTable["powerFilters"][classFileName][buttons[i]]
                selected = filter.selectedLayoutTable["powerFilters"][classFileName][buttons[i]]
            end
            UpdateButtonSelection(b, selected)
            -- update now, if selectedLayout == currentLayout
            if filter.selectedLayout == Cell.vars.currentLayout then
                Cell:Fire("UpdateLayout", filter.selectedLayout, "power")
            end
        end) 
    end

    function filter:LoadConfig(selectedLayout, selectedLayoutTable)
        filter.selectedLayout = selectedLayout
        filter.selectedLayoutTable = selectedLayoutTable

        if type(selectedLayoutTable["powerFilters"][classFileName]) == "boolean" then
            UpdateButtonSelection(filter.buttons["DAMAGER"], selectedLayoutTable["powerFilters"][classFileName])
        else
            for role, b in pairs(filter.buttons) do
                UpdateButtonSelection(b, selectedLayoutTable["powerFilters"][classFileName][role])
            end
        end
    end

    return filter
end

-----------------------------------------
-- Button Group
-----------------------------------------
function addon:CreateButtonGroup(buttons, onClick, func1, func2, onEnter, onLeave)
    local function HighlightButton(id)
        for _, b in pairs(buttons) do
            if id == b.id then
                b:SetBackdropColor(unpack(b.hoverColor))
                b:SetScript("OnEnter", function()
                    if b.ShowTooltip then b.ShowTooltip(b) end
                    if onEnter then onEnter(b) end
                end)
                b:SetScript("OnLeave", function()
                    if b.HideTooltip then b.HideTooltip() end
                    if onLeave then onLeave() end
                end)
                if func1 then func1(b.id) end
            else
                b:SetBackdropColor(unpack(b.color))
                b:SetScript("OnEnter", function() 
                    if b.ShowTooltip then b.ShowTooltip(b) end
                    b:SetBackdropColor(unpack(b.hoverColor))
                    if onEnter then onEnter(b) end
                end)
                b:SetScript("OnLeave", function() 
                    if b.HideTooltip then b.HideTooltip() end
                    b:SetBackdropColor(unpack(b.color))
                    if onLeave then onLeave() end
                end)
                if func2 then func2(b.id) end
            end
        end
    end

    for _, b in pairs(buttons) do
        b:SetScript("OnClick", function()
            HighlightButton(b.id)
            onClick(b.id, b)
        end)
    end

    return HighlightButton
end

-----------------------------------------
-- check button
-----------------------------------------
function addon:CreateCheckButton(parent, label, onClick, ...)
    -- InterfaceOptionsCheckButtonTemplate --> FrameXML\InterfaceOptionsPanels.xml line 19
    -- OptionsBaseCheckButtonTemplate -->  FrameXML\OptionsPanelTemplates.xml line 10
    
    local cb = CreateFrame("CheckButton", nil, parent, "BackdropTemplate")
    cb.onClick = onClick
    cb:SetScript("OnClick", function(self)
        PlaySound(self:GetChecked() and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
        if cb.onClick then cb.onClick(self:GetChecked() and true or false, self) end
    end)
    
    cb.label = cb:CreateFontString(nil, "OVERLAY", font_name)
    cb.label:SetText(label)
    cb.label:SetPoint("LEFT", cb, "RIGHT", P:Scale(5), 0)
    -- cb.label:SetTextColor(accentColor.t[1], accentColor.t[2], accentColor.t[3])
    
    P:Size(cb, 14, 14)
    if strtrim(label) ~= "" then
        cb:SetHitRectInsets(0, -cb.label:GetStringWidth()-5, 0, 0)
    end

    cb:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    cb:SetBackdropColor(0.115, 0.115, 0.115, 0.9)
    cb:SetBackdropBorderColor(0, 0, 0, 1)

    local checkedTexture = cb:CreateTexture(nil, "ARTWORK")
    checkedTexture:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.7)
    checkedTexture:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
    checkedTexture:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))

    local highlightTexture = cb:CreateTexture(nil, "ARTWORK")
    highlightTexture:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.1)
    highlightTexture:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
    highlightTexture:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))
    
    cb:SetCheckedTexture(checkedTexture)
    cb:SetHighlightTexture(highlightTexture, "ADD")
    -- cb:SetDisabledCheckedTexture([[Interface\AddOns\Cell\Media\CheckBox\CheckBox-DisabledChecked-16x16]])

    cb:SetScript("OnEnable", function()
        cb.label:SetTextColor(1, 1, 1)
        checkedTexture:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.7)
        cb:SetBackdropBorderColor(0, 0, 0, 1)
    end)

    cb:SetScript("OnDisable", function()
        cb.label:SetTextColor(0.4, 0.4, 0.4)
        checkedTexture:SetColorTexture(0.4, 0.4, 0.4)
        cb:SetBackdropBorderColor(0, 0, 0, 0.4)
    end)

    function cb:SetText(text)
        cb.label:SetText(text)
        if strtrim(label) ~= "" then
            cb:SetHitRectInsets(0, -cb.label:GetStringWidth()-5, 0, 0)
        else
            cb:SetHitRectInsets(0, 0, 0, 0)
        end
    end

    addon:SetTooltips(cb, "ANCHOR_TOPLEFT", 0, 2, ...)

    return cb
end

-----------------------------------------
-- colorpicker
-----------------------------------------
function addon:CreateColorPicker(parent, label, hasOpacity, onChange, onConfirm)
    local cp = CreateFrame("Button", nil, parent, "BackdropTemplate")
    P:Size(cp, 14, 14)
    cp:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    cp:SetBackdropBorderColor(0, 0, 0, 1)
    cp:SetScript("OnEnter", function()
        cp:SetBackdropBorderColor(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.5)
    end)
    cp:SetScript("OnLeave", function()
        cp:SetBackdropBorderColor(0, 0, 0, 1)
    end)

    cp.label = cp:CreateFontString(nil, "OVERLAY", font_name)
    cp.label:SetText(label)
    cp.label:SetPoint("LEFT", cp, "RIGHT", 5, 0)

    cp.mask = cp:CreateTexture(nil, "ARTWORK")
    cp.mask:SetColorTexture(0.15, 0.15, 0.15, 0.7)
    cp.mask:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
    cp.mask:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))
    cp.mask:Hide()
    
    -- local function ColorCallback(restore)
    --     local newR, newG, newB, newA
    --     if restore then
    --         newR, newG, newB, newA = unpack(restore)
    --     else
    --         newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
    --     end
        
    --     newR, newG, newB, newA = tonumber(string.format("%.3f", newR)), tonumber(string.format("%.3f", newG)), tonumber(string.format("%.3f", newB)), newA and tonumber(string.format("%.3f", newA))
        
    --     newA = hasOpacity and newA or 1
        
    --     cp:SetBackdropColor(newR, newG, newB, newA)
    --     if func then
    --         func(newR, newG, newB, newA)
    --         cp.color[1] = newR
    --         cp.color[2] = newG
    --         cp.color[3] = newB
    --         cp.color[4] = newA
    --     end
    -- end
    
    -- local function ShowColorPicker()
    --     ColorPickerFrame.hasOpacity = hasOpacity
    --     ColorPickerFrame.opacity = cp.color[4]
    --     ColorPickerFrame.previousValues = {unpack(cp.color)}
    --     ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = ColorCallback, ColorCallback, ColorCallback
    --     ColorPickerFrame:SetColorRGB(unpack(cp.color))
    --     ColorPickerFrame:Hide()
    --     ColorPickerFrame:Show()
    -- end
    
    cp:SetScript("OnClick", function()
        addon:ShowColorPicker(function(r, g, b, a)
            cp:SetBackdropColor(r, g, b, a)
            cp.color[1] = r
            cp.color[2] = g
            cp.color[3] = b
            cp.color[4] = a
            if onChange then
                onChange(r, g, b, a)
            end
        end, onConfirm, hasOpacity, unpack(cp.color))
    end)

    cp.color = {1, 1, 1, 1}
    function cp:SetColor(arg1, arg2, arg3, arg4)
        if type(arg1) == "table" then
            cp.color[1] = arg1[1]
            cp.color[2] = arg1[2]
            cp.color[3] = arg1[3]
            cp.color[4] = arg1[4]
            cp:SetBackdropColor(unpack(arg1))
        else
            cp.color[1] = arg1
            cp.color[2] = arg2
            cp.color[3] = arg3
            cp.color[4] = arg4
            cp:SetBackdropColor(arg1, arg2, arg3, arg4)
        end
    end

    function cp:GetColor()
        return cp.color
    end

    cp:SetScript("OnEnable", function()
        cp.label:SetTextColor(1, 1, 1, 1)
        cp.mask:Hide()
    end)
    cp:SetScript("OnDisable", function()
        cp.label:SetTextColor(0.4, 0.4, 0.4, 1)
        cp.mask:Show()
    end)

    return cp
end

-----------------------------------------
-- editbox
-----------------------------------------
function addon:CreateEditBox(parent, width, height, isTransparent, isMultiLine, isNumeric, font)
    local eb = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
    if not isTransparent then addon:StylizeFrame(eb, {0.115, 0.115, 0.115, 0.9}) end
    eb:SetFontObject(font or font_name)
    eb:SetMultiLine(isMultiLine)
    eb:SetMaxLetters(0)
    eb:SetJustifyH("LEFT")
    eb:SetJustifyV("MIDDLE")
    P:Width(eb, width or 0)
    P:Height(eb, height or 0)
    eb:SetTextInsets(5, 5, 0, 0)
    eb:SetAutoFocus(false)
    eb:SetNumeric(isNumeric)
    eb:SetScript("OnEscapePressed", function() eb:ClearFocus() end)
    eb:SetScript("OnEnterPressed", function() eb:ClearFocus() end)
    eb:SetScript("OnEditFocusGained", function() eb:HighlightText() end)
    eb:SetScript("OnEditFocusLost", function() eb:HighlightText(0, 0) end)
    eb:SetScript("OnDisable", function() eb:SetTextColor(0.4, 0.4, 0.4, 1) end)
    eb:SetScript("OnEnable", function() eb:SetTextColor(1, 1, 1, 1) end)

    return eb
end

function addon:CreateScrollEditBox(parent, onTextChanged, scrollStep)
    scrollStep = scrollStep or 1

    local frame = CreateFrame("Frame", nil, parent)
    addon:CreateScrollFrame(frame)
    addon:StylizeFrame(frame.scrollFrame, {0.15, 0.15, 0.15, 0.9})
    
    frame.eb = addon:CreateEditBox(frame.scrollFrame.content, 10, 20, true, true)
    frame.eb:SetPoint("TOPLEFT")
    frame.eb:SetPoint("RIGHT")
    frame.eb:SetTextInsets(2, 2, 2, 2)
    frame.eb:SetScript("OnEditFocusGained", nil)
    frame.eb:SetScript("OnEditFocusLost", nil)

    frame.eb:SetScript("OnEnterPressed", function(self) self:Insert("\n") end)

    -- https://wow.gamepedia.com/UIHANDLER_OnCursorChanged
    frame.eb:SetScript("OnCursorChanged", function(self, x, y, arg, lineHeight)
        frame.scrollFrame:SetScrollStep((lineHeight + frame.eb:GetSpacing()) * scrollStep)

        local vs = frame.scrollFrame:GetVerticalScroll()
        local h  = frame.scrollFrame:GetHeight()

        local cursorHeight = lineHeight - y

        if vs + y > 0 then -- cursor above current view
            frame.scrollFrame:SetVerticalScroll(-y)
        elseif cursorHeight > h + vs then
            frame.scrollFrame:SetVerticalScroll(-y-h+lineHeight+arg)
        end

        if frame.scrollFrame:GetVerticalScroll() > frame.scrollFrame:GetVerticalScrollRange() then frame.scrollFrame:ScrollToBottom() end
    end)

    frame.eb:SetScript("OnTextChanged", function(self, userChanged)
        frame.scrollFrame:SetContentHeight(self:GetHeight())
        if onTextChanged then
            onTextChanged(self, userChanged)
        end
    end)

    frame.scrollFrame:SetScript("OnMouseDown", function()
        frame.eb:SetFocus(true)
    end)

    function frame:SetText(text)
        frame.eb:SetText(text)
        frame.scrollFrame:ResetScroll()
        frame.eb:SetCursorPosition(0)
    end

    function frame:GetText()
        return frame.eb:GetText()
    end

    function frame:SetEnabled(enabled)
        frame.eb:SetEnabled(enabled)
    end

    return frame
end

-----------------------------------------
-- slider 2020-08-25 02:49:16
-----------------------------------------
-- Interface\FrameXML\OptionsPanelTemplates.xml, line 76, OptionsSliderTemplate
function addon:CreateSlider(name, parent, low, high, width, step, onValueChangedFn, afterValueChangedFn, isPercentage, ...)
    local tooltips = {...}
    local slider = CreateFrame("Slider", nil, parent, "BackdropTemplate")
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    slider:SetOrientation("HORIZONTAL")
    P:Size(slider, width, 10)
    local unit = isPercentage and "%" or ""

    addon:StylizeFrame(slider, {0.115, 0.115, 0.115, 1})
    
    local nameText = slider:CreateFontString(nil, "OVERLAY", font_name)
    nameText:SetText(name)
    nameText:SetPoint("BOTTOM", slider, "TOP", 0, 2)

    function slider:SetName(n)
        nameText:SetText(n)
    end

    local currentEditBox = addon:CreateEditBox(slider, 48, 14)
    slider.currentEditBox = currentEditBox
    P:Point(currentEditBox, "TOPLEFT", slider, "BOTTOMLEFT", math.ceil(width / 2 - 24), -1)
    -- currentEditBox:SetPoint("TOP", slider, "BOTTOM", 0, -1)
    currentEditBox:SetJustifyH("CENTER")
    currentEditBox:SetScript("OnEditFocusGained", function(self)
        self:HighlightText()
    end)
    currentEditBox:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
        local value = tonumber(self:GetText())
        -- if isPercentage then
        --     value = string.gsub(self:GetText(), "%%", "")
        --     value = tonumber(value)
        -- else
        --     value = tonumber(self:GetText())
        -- end

        if value == self.oldValue then return end
        if value then
            if value < slider.low then value = slider.low end
            if value > slider.high then value = slider.high end
            self:SetText(value)
            slider:SetValue(value)
            if slider.onValueChangedFn then slider.onValueChangedFn(value) end
            if slider.afterValueChangedFn then slider.afterValueChangedFn(value) end
        else
            self:SetText(self.oldValue)
        end
    end)
    currentEditBox:SetScript("OnShow", function(self)
        if self.oldValue then self:SetText(self.oldValue) end
    end)

    local lowText = slider:CreateFontString(nil, "OVERLAY", font_name)
    slider.lowText = lowText
    lowText:SetTextColor(unpack(colors.grey.t))
    lowText:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, -1)
    lowText:SetPoint("BOTTOM", currentEditBox)
    
    local highText = slider:CreateFontString(nil, "OVERLAY", font_name)
    slider.highText = highText
    highText:SetTextColor(unpack(colors.grey.t))
    highText:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 0, -1)
    highText:SetPoint("BOTTOM", currentEditBox)

    local tex = slider:CreateTexture(nil, "ARTWORK")
    tex:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.7)
    tex:SetSize(8, 8)
    slider:SetThumbTexture(tex)

    local valueBeforeClick
    slider.onEnter = function()
        tex:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 1)
        valueBeforeClick = slider:GetValue()
        if #tooltips > 0 then
            ShowTooltips(slider, "ANCHOR_TOPLEFT", 0, 3, tooltips)
        end
    end
    slider:SetScript("OnEnter", slider.onEnter)
    slider.onLeave = function()
        tex:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.7)
        CellTooltip:Hide()
    end
    slider:SetScript("OnLeave", slider.onLeave)

    slider.onValueChangedFn = onValueChangedFn
    slider.afterValueChangedFn = afterValueChangedFn
    
    -- if tooltip then slider.tooltipText = tooltip end

    local oldValue
    slider:SetScript("OnValueChanged", function(self, value, userChanged)
        if oldValue == value then return end
        oldValue = value

        if math.floor(value) < value then -- decimal
            value = tonumber(string.format("%.2f", value))
        end

        currentEditBox:SetText(value)
        currentEditBox.oldValue = value
        if userChanged and slider.onValueChangedFn then slider.onValueChangedFn(value) end
    end)

    -- local valueBeforeClick
    -- slider:HookScript("OnEnter", function(self, button, isMouseOver)
    --     valueBeforeClick = slider:GetValue()
    -- end)

    slider:SetScript("OnMouseUp", function(self, button, isMouseOver)
        if not slider:IsEnabled() then return end

        -- oldValue here == newValue, OnMouseUp called after OnValueChanged
        if valueBeforeClick ~= oldValue and slider.afterValueChangedFn then
            valueBeforeClick = oldValue
            local value = slider:GetValue()
            if math.floor(value) < value then -- decimal
                value = tonumber(string.format("%.2f", value))
            end
            slider.afterValueChangedFn(value)
        end
    end)

    --[[
    slider:EnableMouseWheel(true)
    slider:SetScript("OnMouseWheel", function(self, delta)
        if not IsShiftKeyDown() then return end

        -- NOTE: OnValueChanged may not be called: value == low
        oldValue = oldValue and oldValue or low

        local value
        if delta == 1 then -- scroll up
            value = oldValue + step
            value = value > high and high or value
        elseif delta == -1 then -- scroll down
            value = oldValue - step
            value = value < low and low or value
        end
        
        if value ~= oldValue then
            slider:SetValue(value)
            if slider.onValueChangedFn then slider.onValueChangedFn(value) end
            if slider.afterValueChangedFn then slider.afterValueChangedFn(value) end
        end
    end)
    ]]
    
    slider:SetValue(low) -- NOTE: needs to be after OnValueChanged

    slider:SetScript("OnDisable", function()
        nameText:SetTextColor(0.4, 0.4, 0.4)
        currentEditBox:SetEnabled(false)
        slider:SetScript("OnEnter", nil)
        slider:SetScript("OnLeave", nil)
        tex:SetColorTexture(0.4, 0.4, 0.4, 0.7)
        lowText:SetTextColor(0.4, 0.4, 0.4)
        highText:SetTextColor(0.4, 0.4, 0.4)
    end)
    
    slider:SetScript("OnEnable", function()
        nameText:SetTextColor(1, 1, 1)
        currentEditBox:SetEnabled(true)
        slider:SetScript("OnEnter", slider.onEnter)
        slider:SetScript("OnLeave", slider.onLeave)
        tex:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.7)
        lowText:SetTextColor(unpack(colors.grey.t))
        highText:SetTextColor(unpack(colors.grey.t))
    end)

    function slider:UpdateMinMaxValues(minV, maxV)
        slider:SetMinMaxValues(minV, maxV)
        slider.low = minV
        slider.high = maxV
        lowText:SetText(minV..unit)
        highText:SetText(maxV..unit)
    end
    slider:UpdateMinMaxValues(low, high)
    
    return slider
end

-----------------------------------------
-- switch
-----------------------------------------
function addon:CreateSwitch(parent, size, leftText, leftValue, rightText, rightValue, func)
    local switch = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    P:Size(switch, size[1], size[2])
    addon:StylizeFrame(switch, {0.115, 0.115, 0.115, 1})
    
    local textLeft = switch:CreateFontString(nil, "OVERLAY", font_name)
    textLeft:SetPoint("LEFT", 2, 0)
    textLeft:SetPoint("RIGHT", switch, "CENTER", -1, 0)
    textLeft:SetText(leftText)
    
    local textRight = switch:CreateFontString(nil, "OVERLAY", font_name)
    textRight:SetPoint("LEFT", switch, "CENTER", 1, 0)
    textRight:SetPoint("RIGHT", -2, 0)
    textRight:SetText(rightText)

    local highlight = switch:CreateTexture(nil, "ARTWORK")
    if class == "PRIEST" and not accentColorOverride then
        highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.35)
    else
        highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.45)
    end

    local function UpdateHighlight(which)
        highlight:ClearAllPoints()
        if which == "LEFT" then
            highlight:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
            highlight:SetPoint("RIGHT", switch, "CENTER")
            highlight:SetPoint("BOTTOM", 0, P:Scale(1))
        else
            highlight:SetPoint("TOPRIGHT", P:Scale(-1), P:Scale(-1))
            highlight:SetPoint("LEFT", switch, "CENTER")
            highlight:SetPoint("BOTTOM", 0, P:Scale(1))
        end
    end

    local ag = highlight:CreateAnimationGroup()
    local t1 = ag:CreateAnimation("Translation")
    t1:SetOffset(highlight:GetWidth(), 0)
    t1:SetDuration(0.2)
    t1:SetSmoothing("IN_OUT")
    ag:SetScript("OnPlay", function()
        switch.isPlaying = true -- prevent continuous clicking
    end)
    ag:SetScript("OnFinished", function()
        switch.isPlaying = false
        if switch.selected == "LEFT" then
            switch:SetSelected("RIGHT", true)
        elseif switch.selected == "RIGHT" then
            switch:SetSelected("LEFT", true)
        end
    end)
    
    function switch:SetSelected(value, runFunc)
        if value == leftValue or value == "LEFT" then
            switch.selected = "LEFT"
            switch.selectedValue = leftValue
            UpdateHighlight("LEFT")
            t1:SetOffset(highlight:GetWidth(), 0)
            
        elseif value == rightValue or value == "RIGHT" then
            switch.selected = "RIGHT"
            switch.selectedValue = rightValue
            UpdateHighlight("RIGHT")
            t1:SetOffset(-highlight:GetWidth(), 0)
        end

        if func and runFunc then func(switch.selectedValue) end
    end

    switch:SetScript("OnMouseDown", function()
        if switch.selected and not switch.isPlaying then
            ag:Play()
        end
    end)

    switch:SetScript("OnEnter", function()
        if class == "PRIEST" and not accentColorOverride then
            highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.55)
        else
            highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.65)
        end
    end)

    switch:SetScript("OnLeave", function()
        if class == "PRIEST" and not accentColorOverride then
            highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.35)
        else
            highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.45)
        end
    end)

    return switch
end

function addon:CreateTripleSwitch(parent, size, func)
    local switch = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    P:Size(switch, size[1], size[2])
    addon:StylizeFrame(switch, {0.115, 0.115, 0.115, 1})
    
    local highlight = switch:CreateTexture(nil, "ARTWORK")
    if class == "PRIEST" and not accentColorOverride then
        highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.35)
    else
        highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.45)
    end

    local function UpdateHighlight(which)
        local width = size[1] - 2

        highlight:ClearAllPoints()
        if which == "LEFT" then
            highlight:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
            highlight:SetPoint("BOTTOMRIGHT", switch, "BOTTOMLEFT", P:Scale(width/3+1), P:Scale(1))
        elseif which == "CENTER" then
            highlight:SetPoint("TOPLEFT", P:Scale(width/3+1), P:Scale(-1))
            highlight:SetPoint("BOTTOMRIGHT", P:Scale(-width/3-1), P:Scale(1))
        else
            highlight:SetPoint("TOPLEFT", P:Scale(width/3*2+1), P:Scale(-1))
            highlight:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))
        end
    end

    local ag = highlight:CreateAnimationGroup()
    local t1 = ag:CreateAnimation("Translation")
    -- t1:SetOffset(highlight:GetWidth(), 0)
    t1:SetDuration(0.2)
    t1:SetSmoothing("IN_OUT")
    ag:SetScript("OnPlay", function()
        switch.isPlaying = true -- prevent continuous clicking
    end)
    ag:SetScript("OnFinished", function()
        switch.isPlaying = false
        if switch.selected == "LEFT" then
            switch:SetSelected("CENTER", true)
        elseif switch.selected == "CENTER" then
            switch:SetSelected("RIGHT", true)
        else
            switch:SetSelected("LEFT", true)
        end
    end)
    
    function switch:SetSelected(value, runFunc)
        local width = size[1] - 2

        if value == "LEFT" then
            switch.selected = "LEFT"
            UpdateHighlight("LEFT")
            t1:SetOffset(width/3, 0)
            
        elseif value == "CENTER" then
            switch.selected = "CENTER"
            UpdateHighlight("CENTER")
            t1:SetOffset(width/3, 0)
        else
            switch.selected = "RIGHT"
            UpdateHighlight("RIGHT")
            t1:SetOffset(-width/3*2, 0)
        end

        if func and runFunc then func(value) end
    end

    switch:SetScript("OnMouseDown", function()
        if switch.selected and not switch.isPlaying then
            ag:Play()
        end
    end)

    switch:SetScript("OnEnter", function()
        if class == "PRIEST" and not accentColorOverride then
            highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.55)
        else
            highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.65)
        end
    end)

    switch:SetScript("OnLeave", function()
        if class == "PRIEST" and not accentColorOverride then
            highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.35)
        else
            highlight:SetColorTexture(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.45)
        end
    end)

    return switch
end

-----------------------------------------
-- status bar
-----------------------------------------
function addon:CreateStatusBar(name, parent, width, height, maxValue, smooth, func, showText, texture, color)
    local bar = CreateFrame("StatusBar", name, parent, "BackdropTemplate")

    if not color then color = {accentColor.t[1], accentColor.t[2], accentColor.t[3], 1} end
    if not texture then
        local tex = bar:CreateTexture(nil, "ARTWORK")
        tex:SetColorTexture(1, 1, 1, 1)

        bar:SetStatusBarTexture(tex)
        bar:SetStatusBarColor(unpack(color))
    else
        bar:SetStatusBarTexture(texture)
        bar:SetStatusBarColor(unpack(color))
    end
    
    -- bar:GetStatusBarTexture():SetHorizTile(false)
    -- REVIEW: in 9.0, edgeSize = -1 will case a thicker outline
    local border = CreateFrame("Frame", nil, bar, "BackdropTemplate")
    bar.border = border
    border:SetBackdrop({edgeFile="Interface\\Buttons\\WHITE8x8", edgeSize=P:Scale(1)})
    border:SetBackdropBorderColor(0, 0, 0, 1)
    P:Point(border, "TOPLEFT", bar, "TOPLEFT", -1, 1)
    P:Point(border, "BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)

    P:Width(bar, width)
    P:Height(bar, height)
    bar:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8"})
    bar:SetBackdropColor(0.07, 0.07, 0.07, 0.9)
    -- bar:SetBackdropBorderColor(0, 0, 0, 1)

    if showText then
        bar.text = bar:CreateFontString(nil, "OVERLAY", font_name)
        bar.text:SetJustifyH("CENTER")
        bar.text:SetJustifyV("MIDDLE")
        bar.text:SetPoint("CENTER")
        bar.text:SetText("0%")
    end

    bar:SetMinMaxValues(0, maxValue)
    bar:SetValue(0)
    if smooth then Mixin(bar, SmoothStatusBarMixin) end -- Interface\SharedXML\SmoothStatusBar.lua

    function bar:SetMaxValue(m)
        maxValue = m
        if smooth then
            bar:SetMinMaxSmoothedValue(0, m)
        else
            bar:SetMinMaxValues(0, m)
        end
    end
    
    function bar:Reset()
        if smooth then
            bar:SetSmoothedValue(0)
        else
            bar:SetValue(0)
        end
    end

    bar:SetScript("OnValueChanged", function(self, value)
        if showText then
            bar.text:SetText(format("%d%%", value / maxValue * 100))
        end
        
        if func then func() end
    end)

    bar:SetScript("OnHide", function()
        bar:SetValue(0)
    end)

    function bar:UpdatePixelPerfect()
        P:Resize(bar)
        P:Repoint(bar)
        border:SetBackdrop({edgeFile="Interface\\Buttons\\WHITE8x8", edgeSize=P:Scale(1)})
        border:SetBackdropBorderColor(0, 0, 0, 1)
        P:Repoint(border)
    end

    return bar
end

function addon:CreateStatusBarButton(parent, text, size, maxValue, template)
    local b = Cell:CreateButton(parent, text, "accent-hover", size, false, true, nil, nil, template)
    b:SetFrameLevel(parent:GetFrameLevel()+2)
    b:SetBackdropColor(0, 0, 0, 0)
    b:SetScript("OnEnter", function()
        b:SetBackdropBorderColor(unpack(accentColor.t))
    end)
    b:SetScript("OnLeave", function()
        b:SetBackdropBorderColor(0, 0, 0, 1)
    end)
    
    local bar = CreateFrame("StatusBar", nil, b, "BackdropTemplate")
    b.bar = bar
    bar:SetPoint("TOPLEFT", b)
    bar:SetPoint("BOTTOMRIGHT", b)
    bar:SetStatusBarTexture("Interface\\AddOns\\Cell\\Media\\statusbar.tga")
    bar:SetStatusBarColor(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.5)
    bar:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1})
    bar:SetBackdropColor(0.115, 0.115, 0.115, 1)
    bar:SetBackdropBorderColor(0, 0, 0, 0)
    P:Size(bar, size[1], size[2])
    bar:SetMinMaxValues(0, maxValue)
    bar:SetValue(0)
    bar:SetFrameLevel(parent:GetFrameLevel()+1)
    
    function b:Start()
        bar:SetValue(select(2, bar:GetMinMaxValues()))
        bar:SetScript("OnUpdate", function(self, elapsed)
            bar:SetValue(bar:GetValue()-elapsed)
            if bar:GetValue() <= 0 then
                b:Stop()
            end
        end)
    end

    function b:Stop()
        bar:SetValue(0)
        bar:SetScript("OnUpdate", nil)
    end

    function b:SetMaxValue(value)
        bar:SetMinMaxValues(0, value)
        bar:SetValue(value)
    end

    b._UpdatePixelPerfect = b.UpdatePixelPerfect -- store UpdatePixelPerfect in CreateButton
    function b:UpdatePixelPerfect()
        b:_UpdatePixelPerfect()

        P:Resize(bar)
        P:Repoint(bar)

        -- update bar
        -- backup colors
        local currentBackdropColor = {bar:GetBackdropColor()}
        local currentBackdropBorderColor = {bar:GetBackdropBorderColor()}
        -- update backdrop
        bar:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
        -- restore colors
        bar:SetBackdropColor(unpack(currentBackdropColor))
        bar:SetBackdropBorderColor(unpack(currentBackdropBorderColor))
        currentBackdropColor = nil
        currentBackdropBorderColor = nil
    end
    
    return b
end

-----------------------------------------
-- mask
-----------------------------------------
function addon:CreateMask(parent, text, points) -- points = {topleftX, topleftY, bottomrightX, bottomrightY}
    if not parent.mask then -- not init
        parent.mask = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        addon:StylizeFrame(parent.mask, {0.15, 0.15, 0.15, 0.7}, {0, 0, 0, 0})
        parent.mask:SetFrameStrata("HIGH")
        parent.mask:SetFrameLevel(parent:GetFrameLevel()+20)
        parent.mask:EnableMouse(true) -- can't click-through
        parent.mask:EnableMouseWheel(true) -- can't scroll-through

        parent.mask.text = parent.mask:CreateFontString(nil, "OVERLAY", font_title_name)
        parent.mask.text:SetTextColor(1, 0.2, 0.2)
        parent.mask.text:SetPoint("LEFT", 5, 0)
        parent.mask.text:SetPoint("RIGHT", -5, 0)

        -- parent.mask:SetScript("OnUpdate", function()
        -- 	if not parent:IsVisible() then
        -- 		parent.mask:Hide()
        -- 	end
        -- end)
    end

    if not text then text = "" end
    parent.mask.text:SetText(text)

    parent.mask:ClearAllPoints() -- prepare for SetPoint()
    if points then
        local tlX, tlY, brX, brY = unpack(points)
        parent.mask:SetPoint("TOPLEFT", P:Scale(tlX), P:Scale(tlY))
        parent.mask:SetPoint("BOTTOMRIGHT", P:Scale(brX), P:Scale(brY))
    else
        parent.mask:SetAllPoints(parent) -- anchor points are set to those of its "parent"
    end
    parent.mask:Show()
end

function addon:CreateCombatMask(parent)
    local mask = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    parent.combatMask = mask

    mask:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
    mask:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))

    addon:StylizeFrame(mask, {0.17, 0.15, 0.15, 0.8}, {0, 0, 0, 0})
    mask:SetFrameStrata("DIALOG")
    mask:SetFrameLevel(parent:GetFrameLevel()+70)
    mask:EnableMouse(true) -- can't click-through
    mask:EnableMouseWheel(true) -- can't scroll-through

    mask.text = mask:CreateFontString(nil, "OVERLAY", font_title_name)
    mask.text:SetTextColor(1, 0.2, 0.2)
    mask.text:SetPoint("LEFT", 5, 0)
    mask.text:SetPoint("RIGHT", -5, 0)
    mask.text:SetText(L["Can't change options in combat"])

    mask:Hide()
end

-----------------------------------------
-- create popup (delete/edit/... confirm) with mask
-----------------------------------------
function addon:CreateConfirmPopup(parent, width, text, onAccept, onReject, mask, hasEditBox, dropdowns)
    if not parent.confirmPopup then -- not init
        parent.confirmPopup = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        parent.confirmPopup:SetSize(width, 100)
        addon:StylizeFrame(parent.confirmPopup, {0.1, 0.1, 0.1, 0.95}, {accentColor.t[1], accentColor.t[2], accentColor.t[3], 1})
        parent.confirmPopup:EnableMouse(true)
        parent.confirmPopup:Hide()
        
        parent.confirmPopup:SetScript("OnHide", function()
            parent.confirmPopup:Hide()
            -- hide mask
            if mask and parent.mask then parent.mask:Hide() end
        end)

        parent.confirmPopup.text = parent.confirmPopup:CreateFontString(nil, "OVERLAY", font_title_name)
        parent.confirmPopup.text:SetWordWrap(true)
        parent.confirmPopup.text:SetSpacing(3)
        parent.confirmPopup.text:SetJustifyH("CENTER")
        parent.confirmPopup.text:SetPoint("TOPLEFT", 5, -8)
        parent.confirmPopup.text:SetPoint("TOPRIGHT", -5, -8)

        -- yes
        parent.confirmPopup.button1 = addon:CreateButton(parent.confirmPopup, L["Yes"], "green", {35, 15})
        -- button1:SetPoint("BOTTOMRIGHT", -45, 0)
        parent.confirmPopup.button1:SetPoint("BOTTOMRIGHT", -34, 0)
        parent.confirmPopup.button1:SetBackdropBorderColor(accentColor.t[1], accentColor.t[2], accentColor.t[3], 1)
        -- no
        parent.confirmPopup.button2 = addon:CreateButton(parent.confirmPopup, L["No"], "red", {35, 15})
        parent.confirmPopup.button2:SetPoint("LEFT", parent.confirmPopup.button1, "RIGHT", P:Scale(-1), 0)
        parent.confirmPopup.button2:SetBackdropBorderColor(accentColor.t[1], accentColor.t[2], accentColor.t[3], 1)
    end

    if hasEditBox then
        if not parent.confirmPopup.editBox then
            parent.confirmPopup.editBox = addon:CreateEditBox(parent.confirmPopup, width-40, 20)
            parent.confirmPopup.editBox:SetPoint("TOP", parent.confirmPopup.text, "BOTTOM", 0, -5)
            parent.confirmPopup.editBox:SetAutoFocus(true)
            parent.confirmPopup.editBox:SetScript("OnHide", function()
                parent.confirmPopup.editBox:SetText("")
            end)
        end
        parent.confirmPopup.editBox:Show()
        -- disable yes if editBox empty
        parent.confirmPopup.editBox:SetScript("OnTextChanged", function()
            if not parent.confirmPopup.editBox:GetText() or strtrim(parent.confirmPopup.editBox:GetText()) == "" then
                parent.confirmPopup.button1:SetEnabled(false)
            else
                parent.confirmPopup.button1:SetEnabled(true)
            end
        end)
    elseif parent.confirmPopup.editBox then
        parent.confirmPopup.editBox:Hide()
        parent.confirmPopup.editBox:SetScript("OnTextChanged", nil)
        parent.confirmPopup.button1:SetEnabled(true)
    end

    if dropdowns then
        if not parent.confirmPopup.dropdown1 then
            parent.confirmPopup.dropdown1 = addon:CreateDropdown(parent.confirmPopup, width-40)
            parent.confirmPopup.dropdown1:SetPoint("LEFT", 20, 0)
            if hasEditBox then
                parent.confirmPopup.dropdown1:SetPoint("TOP", parent.confirmPopup.editBox, "BOTTOM", 0, -5)
            else
                parent.confirmPopup.dropdown1:SetPoint("TOP", parent.confirmPopup.text, "BOTTOM", 0, -5)
            end
        end
        if not parent.confirmPopup.dropdown2 then
            parent.confirmPopup.dropdown2 = addon:CreateDropdown(parent.confirmPopup, (width-40)/2-3)
            parent.confirmPopup.dropdown2:SetPoint("LEFT", parent.confirmPopup.dropdown1, "RIGHT", 5, 0)
        end

        if dropdowns == 1 then
            parent.confirmPopup.dropdown1:Show()
            parent.confirmPopup.dropdown2:Hide()
        elseif dropdowns == 2 then
            parent.confirmPopup.dropdown1:Show()
            parent.confirmPopup.dropdown2:Show()
            parent.confirmPopup.dropdown1:SetWidth((width-40)/2-2)
        end
    elseif parent.confirmPopup.dropdown1 then
        parent.confirmPopup.dropdown1:Hide()
        parent.confirmPopup.dropdown2:Hide()
    end

    if mask then -- show mask?
        if not parent.mask then
            addon:CreateMask(parent, nil, {1, -1, -1, 1})
        else
            parent.mask:Show()
        end
    end

    parent.confirmPopup.button1:SetScript("OnClick", function()
        if onAccept then onAccept(parent.confirmPopup) end
        -- hide mask
        if mask and parent.mask then parent.mask:Hide() end
        parent.confirmPopup:Hide()
    end)

    parent.confirmPopup.button2:SetScript("OnClick", function()
        if onReject then onReject(parent.confirmPopup) end
        -- hide mask
        if mask and parent.mask then parent.mask:Hide() end
        parent.confirmPopup:Hide()
    end)
    
    parent.confirmPopup:SetWidth(width)
    parent.confirmPopup.text:SetText(text)

    -- update height
    parent.confirmPopup:SetScript("OnUpdate", function(self, elapsed)
        local newHeight = parent.confirmPopup.text:GetStringHeight() + 30
        if hasEditBox then newHeight = newHeight + 30 end
        if dropdowns then newHeight = newHeight + 30 end
        parent.confirmPopup:SetHeight(newHeight)
        -- run OnUpdate once, stop updating height
        parent.confirmPopup:SetScript("OnUpdate", nil)
    end)

    parent.confirmPopup:SetFrameStrata("DIALOG")
    parent.confirmPopup:SetFrameLevel(2)
    parent.confirmPopup:ClearAllPoints() -- prepare for SetPoint()
    parent.confirmPopup:Show()

    return parent.confirmPopup
end

-----------------------------------------
-- popup edit box
-----------------------------------------
function addon:CreatePopupEditBox(parent, func, multiLine)
    if not parent.popupEditBox then
        local eb = CreateFrame("EditBox", addonName.."PopupEditBox", parent, "BackdropTemplate")
        parent.popupEditBox = eb
        eb:Hide()
        eb:SetAutoFocus(true)
        eb:SetFontObject(font)
        eb:SetJustifyH("LEFT")
        eb:SetMultiLine(true)
        eb:SetMaxLetters(255)
        eb:SetTextInsets(5, 5, 3, 4)
        addon:StylizeFrame(eb, {0.115, 0.115, 0.115, 1}, {accentColor.t[1], accentColor.t[2], accentColor.t[3], 1})
        
        eb:SetScript("OnEscapePressed", function()
            eb:SetText("")
            eb:Hide()
        end)

        function eb:ShowEditBox(text)
            eb:SetText(text)
            eb:Show()
        end

        local tipsText = eb:CreateFontString(nil, "OVERLAY", font_name)
        tipsText:SetPoint("TOPLEFT", eb, "BOTTOMLEFT", 2, -1)
        tipsText:SetJustifyH("LEFT")
        tipsText:Hide()

        local tipsBackground = eb:CreateTexture(nil, "ARTWORK")
        tipsBackground:SetPoint("TOPLEFT", eb, "BOTTOMLEFT")
        tipsBackground:SetPoint("TOPRIGHT", eb, "BOTTOMRIGHT")
        tipsBackground:SetPoint("BOTTOM", tipsText, 0, -2)
        tipsBackground:SetColorTexture(0.115, 0.115, 0.115, 0.9)
        tipsBackground:Hide()

        function eb:SetTips(text)
            tipsText:SetText(text)
            tipsText:Show()
            tipsBackground:Show()
        end

        eb:SetScript("OnHide", function()
            eb:Hide() -- hide self when parent hides
            tipsText:Hide()
            tipsBackground:Hide()
        end)
    end
    
    parent.popupEditBox:SetScript("OnEnterPressed", function(self)
        if multiLine and IsShiftKeyDown() then -- new line
            self:Insert("\n")
        else
            func(self:GetText())
            self:Hide()
            self:SetText("")
        end
    end)

    -- set parent(for hiding) & size
    parent.popupEditBox:ClearAllPoints()
    parent.popupEditBox:SetFrameStrata("DIALOG")

    return parent.popupEditBox
end

-----------------------------------------
-- cascading menu
-----------------------------------------
local menu = addon:CreateFrame(addonName.."CascadingMenu", UIParent, 100, 20)
addon.menu = menu
tinsert(UISpecialFrames, menu:GetName())
menu:SetClampedToScreen(true)
menu:SetBackdropColor(0.115, 0.115, 0.115, 0.977)
menu:SetBackdropBorderColor(accentColor.t[1], accentColor.t[2], accentColor.t[3], 1)
menu:SetFrameStrata("TOOLTIP")
menu.items = {}

function menu:UpdatePixelPerfect()
    menu:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    menu:SetBackdropColor(0.115, 0.115, 0.115, 0.977)
    menu:SetBackdropBorderColor(Cell:GetAccentColorRGB())
end

-- items: menu items table
-- itemTable: table to store item buttons --> menu/submenu
-- itemParent: menu/submenu
-- level: menu level, 0, 1, 2, 3, ...
local function CreateItemButtons(items, itemTable, itemParent, level)
    itemParent:SetScript("OnHide", function(self) self:Hide() end)

    for i, item in pairs(items) do
        local b
        if itemTable[i] and itemTable[i]:GetObjectType() == "Button" then
            b = itemTable[i]
            b:SetText(item.text)
        else
            b = addon:CreateButton(itemParent, item.text, "transparent-accent", {98 ,18}, true)
            tinsert(itemTable, b)
        end

        b:SetParent(itemParent)
        b:ClearAllPoints()
        if i == 1 then
            b:SetPoint("TOPLEFT", 1, -1)
            b:SetPoint("RIGHT", -1, 0)
        else
            b:SetPoint("TOPLEFT", itemTable[i-1], "BOTTOMLEFT")
            b:SetPoint("RIGHT", itemTable[i-1])
        end

        if item.textColor then
            b:GetFontString():SetTextColor(unpack(item.textColor))
        end

        if item.icon then
            if not b.icon then
                b.iconBg = b:CreateTexture(nil, "BORDER")
                P:Size(b.iconBg, 16, 16)
                b.iconBg:SetPoint("TOPLEFT", P:Scale(5), P:Scale(-1))
                b.iconBg:SetColorTexture(0, 0, 0, 1)

                b.icon = b:CreateTexture(nil, "ARTWORK")
                b.icon:SetPoint("TOPLEFT", b.iconBg, P:Scale(1), P:Scale(-1))
                b.icon:SetPoint("BOTTOMRIGHT", b.iconBg, P:Scale(-1), P:Scale(1))
                b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            end
            b.icon:SetTexture(item.icon)
            b.icon:Show()
            b.iconBg:Show()
            b:GetFontString():SetPoint("LEFT", b.iconBg, "RIGHT", P:Scale(2), 0)
        else
            if b.icon then
                b.icon:Hide()
                b.iconBg:Hide()
            end
            b:GetFontString():SetPoint("LEFT", P:Scale(5), 0)
        end

        if level == 0 then
            b:Show()-- show valid top menu buttons
        else
            b:Hide()
            b:SetScript("OnHide", function(self) self:Hide() end)
        end
        
        if item.children then
            -- create sub menu level+1
            if not menu[level+1] then
                -- menu[level+1] parent == menu[level]
                menu[level+1] = addon:CreateFrame(addonName.."CascadingSubMenu"..level, level == 0 and menu or menu[level], 100, 20)
                menu[level+1]:SetBackdropColor(0.115, 0.115, 0.115, 1)
                menu[level+1]:SetBackdropBorderColor(accentColor.t[1], accentColor.t[2], accentColor.t[3], 1)
                -- menu[level+1]:SetScript("OnHide", function(self) self:Hide() end)
            end

            if not b.childrenSymbol then
                b.childrenSymbol = b:CreateFontString(nil, "OVERLAY", font_name)
                b.childrenSymbol:SetText("|cFF777777>")
                b.childrenSymbol:SetPoint("RIGHT", -5, 0)
            end
            b.childrenSymbol:Show()

            CreateItemButtons(item.children, b, menu[level+1], level+1) -- itemTable == b, insert children to its table
            
            b:SetScript("OnEnter", function()
                b:SetBackdropColor(unpack(b.hoverColor))

                menu[level+1]:Hide()

                menu[level+1]:ClearAllPoints()
                menu[level+1]:SetPoint("TOPLEFT", b, "TOPRIGHT", 2, 1)
                menu[level+1]:Show()

                for _, b in ipairs(b) do
                    b:Show()
                end
            end)

            -- clear parent menuItem's onClick
            b:SetScript("OnClick", function()
                PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
            end)
        else
            if b.childrenSymbol then b.childrenSymbol:Hide() end

            b:SetScript("OnEnter", function()
                b:SetBackdropColor(unpack(b.hoverColor))

                if menu[level+1] then menu[level+1]:Hide() end
            end)

            b:SetScript("OnClick", function()
                PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
                menu:Hide()
                if item.onClick then item.onClick(item.text) end
            end)
        end
    end

    -- update menu/submenu height
    itemParent:SetHeight(2 + #items*18)
end

local function CreateItemButtons_Scroll(items, itemTable, limit)
    menu:SetScript("OnHide", function(self) self:Hide() end)

    for i, item in pairs(items) do
        local b
        if itemTable[i] and itemTable[i]:GetObjectType() == "Button" then
            b = itemTable[i]
            b:SetText(item.text)
        else
            b = addon:CreateButton(menu.scrollFrame.content, item.text, "transparent-accent", {98 ,18}, true)
            tinsert(itemTable, b)
        end
        
        b:Show()
        b:SetParent(menu.scrollFrame.content)
        b:ClearAllPoints()
        if i == 1 then
            b:SetPoint("TOPLEFT", 1, -1)
            b:SetPoint("RIGHT", -1, 0)
        else
            b:SetPoint("TOPLEFT", itemTable[i-1], "BOTTOMLEFT")
            b:SetPoint("RIGHT", itemTable[i-1])
        end

        if item.textColor then
            b:GetFontString():SetTextColor(unpack(item.textColor))
        end

        if item.icon then
            if not b.icon then
                b.iconBg = b:CreateTexture(nil, "BORDER")
                P:Size(b.iconBg, 16, 16)
                b.iconBg:SetPoint("TOPLEFT", P:Scale(5), P:Scale(-1))
                b.iconBg:SetColorTexture(0, 0, 0, 1)

                b.icon = b:CreateTexture(nil, "ARTWORK")
                b.icon:SetPoint("TOPLEFT", b.iconBg, P:Scale(1), P:Scale(-1))
                b.icon:SetPoint("BOTTOMRIGHT", b.iconBg, P:Scale(-1), P:Scale(1))
                b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            end
            b.icon:SetTexture(item.icon)
            b.icon:Show()
            b.iconBg:Show()
            b:GetFontString():SetPoint("LEFT", b.iconBg, "RIGHT", P:Scale(2), 0)
        else
            if b.icon then
                b.icon:Hide()
                b.iconBg:Hide()
            end
            b:GetFontString():SetPoint("LEFT", P:Scale(5), 0)
        end

        -- if item.marker then
        --     if not b.marker then
        --         b.marker = b:CreateTexture(nil, "OVERLAY")
        --         P:Size(b.marker, 16, 16)
        --         b.marker:SetAllPoints(b.iconBg)
        --     end
        --     b.marker:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\icon_marker.tga")
        --     b.marker:SetVertexColor(1, 1, 1, 0.77)
        --     b.marker:SetBlendMode("ADD")
        --     b.marker:Show()
        -- else
        --     if b.marker then
        --         b.marker:Hide()
        --     end
        -- end

        if b.childrenSymbol then b.childrenSymbol:Hide() end

        b:SetScript("OnEnter", function()
            b:SetBackdropColor(unpack(b.hoverColor))
        end)

        b:SetScript("OnClick", function()
            PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
            menu:Hide()
            if item.onClick then item.onClick(item.text) end
        end)
    end

    -- update height
    local n = #items
    menu.scrollFrame:SetContentHeight(P:Scale(2) + n * P:Scale(18))
    if n <= limit then
        menu:SetHeight(P:Scale(2) + n * P:Scale(18))
    else
        menu:SetHeight(P:Scale(2) + limit * P:Scale(18))
    end
end

function menu:SetItems(items, limit)
    -- clear topmenu
    for _, b in pairs({menu:GetChildren()}) do
        if b:GetObjectType() == "Button" then
            b:Hide()
        end
    end

    if not menu.scrollFrame then
        addon:CreateScrollFrame(menu)
        menu.scrollFrame:SetScrollStep(18)
    end
    menu.scrollFrame:Reset()

    -- create buttons -- items, itemTable, itemParent, level
    if limit then
        menu.scrollFrame:Show()
        CreateItemButtons_Scroll(items, menu.items, limit)
    else
        menu.scrollFrame:Hide()
        CreateItemButtons(items, menu.items, menu, 0)
    end
end

function menu:SetWidths(...)
    local widths = {...}
    P:Width(menu, widths[1])
    if #widths == 1 then
        for _, m in ipairs(menu) do
            P:Width(m, widths[1])
        end
    else
        for i, m in ipairs(menu) do
            if widths[i+1] then P:Width(m, widths[i+1]) end
        end
    end
end

function menu:ShowMenu()
    for i, m in ipairs(menu) do
        m:Hide()
    end
    menu:Show()
end

function menu:SetMenuParent(parent)
    menu:SetParent(parent)
    menu:SetFrameStrata("TOOLTIP")
end

-----------------------------------------
-- scroll text frame
-----------------------------------------
function addon:CreateScrollTextFrame(parent, s, timePerScroll, scrollStep, delayTime, noFadeIn)
    if not delayTime then delayTime = 3 end
    if not timePerScroll then timePerScroll = 0.025 end
    if not scrollStep then scrollStep = 1 end

    local frame = CreateFrame("ScrollFrame", nil, parent)
    -- frame:Hide() -- hide by default
    frame:SetHeight(20)

    local content = CreateFrame("Frame", nil, frame)
    content:SetSize(20, 20)
    frame:SetScrollChild(content)

    local text = content:CreateFontString(nil, "OVERLAY", font_name)
    text:SetWordWrap(false)
    text:SetPoint("LEFT")
    text:SetText(s)

    -- alpha changing animation
    local fadeIn = text:CreateAnimationGroup()
    local alpha = fadeIn:CreateAnimation("Alpha")
    alpha:SetFromAlpha(0)
    alpha:SetToAlpha(1)
    alpha:SetDuration(0.5)
    
    local fadeOutIn = text:CreateAnimationGroup()
    local alpha1 = fadeOutIn:CreateAnimation("Alpha")
    alpha1:SetStartDelay(delayTime)
    alpha1:SetFromAlpha(1)
    alpha1:SetToAlpha(0)
    alpha1:SetDuration(0.5)
    alpha1:SetOrder(1)
    local alpha2 = fadeOutIn:CreateAnimation("Alpha")
    alpha2:SetFromAlpha(0)
    alpha2:SetToAlpha(1)
    alpha2:SetDuration(0.5)
    alpha2:SetOrder(2)
    alpha2:SetStartDelay(0.1)

    local maxHScrollRange
    local elapsedTime, delay, scroll = 0, 0, 0
    local nextRound
    
    alpha1:SetScript("OnFinished", function()
        frame:SetHorizontalScroll(0)
    end)

    fadeOutIn:SetScript("OnFinished", function()
        delay = 0
        scroll = 0
        nextRound = false
        wait = false
    end)

    -- init frame
    frame:SetScript("OnShow", function()
        -- init
        if not noFadeIn then fadeIn:Play() end
        frame:SetHorizontalScroll(0)
        elapsedTime, delay, scroll = 0, 0, 0

        -- NOTE: frame:GetWidth() is valid on next OnUpdate
        frame:SetScript("OnUpdate", function()
            if frame:GetWidth() ~= 0 then
                frame:SetScript("OnUpdate", nil)

                if text:GetStringWidth() <= frame:GetWidth() then -- NOTE: frame in a scrollFrame will cause frame:GetWidth() == 0
                    frame:SetScript("OnUpdate", nil)
                else
                    maxHScrollRange = text:GetStringWidth() - frame:GetWidth()
                    frame:SetScript("OnUpdate", function(self, elapsed)
                        elapsedTime = elapsedTime + elapsed
                        delay = delay + elapsed
                        if elapsedTime >= timePerScroll then
                            if not wait and delay >= delayTime then
                                if nextRound then
                                    wait = true
                                    fadeOutIn:Play()
                                elseif scroll >= maxHScrollRange then -- prepare for next round
                                    nextRound = true
                                else
                                    frame:SetHorizontalScroll(scroll)
                                    scroll = scroll + scrollStep
                                end
                            end
                            elapsedTime = 0
                        end
                    end)
                end
            end
        end)
    end)

    function frame:SetText(str)
        text:SetText(str)
        if frame:IsVisible() then
            frame:GetScript("OnShow")()
        end
    end

    return frame
end

-----------------------------------------------------------------------------------
-- create scroll frame (with scrollbar & content frame)
-----------------------------------------------------------------------------------
function addon:CreateScrollFrame(parent, top, bottom, color, border)
    -- create scrollFrame & scrollbar seperately (instead of UIPanelScrollFrameTemplate), in order to custom it
    local scrollFrame = CreateFrame("ScrollFrame", parent:GetName() and parent:GetName().."ScrollFrame" or nil, parent, "BackdropTemplate")
    parent.scrollFrame = scrollFrame
    top = top or 0
    bottom = bottom or 0
    scrollFrame:SetPoint("TOPLEFT", 0, top)
    scrollFrame:SetPoint("BOTTOMRIGHT", 0, bottom)

    if color then
        addon:StylizeFrame(scrollFrame, color, border)
    end

    function scrollFrame:Resize(newTop, newBottom)
        top = newTop
        bottom = newBottom
        scrollFrame:SetPoint("TOPLEFT", 0, top)
        scrollFrame:SetPoint("BOTTOMRIGHT", 0, bottom)
    end
    
    -- content
    local content = CreateFrame("Frame", nil, scrollFrame, "BackdropTemplate")
    content:SetSize(scrollFrame:GetWidth(), 2)
    scrollFrame:SetScrollChild(content)
    scrollFrame.content = content
    -- content:SetFrameLevel(2)
    
    -- scrollbar
    local scrollbar = CreateFrame("Frame", nil, scrollFrame, "BackdropTemplate")
    scrollbar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 2, 0)
    scrollbar:SetPoint("BOTTOMRIGHT", scrollFrame, 7, 0)
    scrollbar:Hide()
    addon:StylizeFrame(scrollbar, {0.1, 0.1, 0.1, 0.8})
    scrollFrame.scrollbar = scrollbar
    
    -- scrollbar thumb
    local scrollThumb = CreateFrame("Frame", nil, scrollbar, "BackdropTemplate")
    scrollThumb:SetWidth(5) -- scrollbar's width is 5
    scrollThumb:SetHeight(scrollbar:GetHeight())
    scrollThumb:SetPoint("TOP")
    addon:StylizeFrame(scrollThumb, {accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.8})
    scrollThumb:EnableMouse(true)
    scrollThumb:SetMovable(true)
    scrollThumb:SetHitRectInsets(-5, -5, 0, 0) -- Frame:SetHitRectInsets(left, right, top, bottom)
    scrollFrame.scrollThumb = scrollThumb
    
    -- reset content height manually ==> content:GetBoundsRect() make it right @OnUpdate
    function scrollFrame:ResetHeight()
        content:SetHeight(2)
    end
    
    -- reset to top, useful when used with DropDownMenu (variable content height)
    function scrollFrame:ResetScroll()
        scrollFrame:SetVerticalScroll(0)
        scrollThumb:SetPoint("TOP")
    end
    
    -- FIXME: GetVerticalScrollRange goes wrong in 9.0.1
    function scrollFrame:GetVerticalScrollRange()
        local range = content:GetHeight() - scrollFrame:GetHeight()
        return range > 0 and range or 0
    end

    -- local scrollRange -- ACCURATE scroll range, for SetVerticalScroll(), instead of scrollFrame:GetVerticalScrollRange()
    function scrollFrame:VerticalScroll(step)
        local scroll = scrollFrame:GetVerticalScroll() + step
        -- if CANNOT SCROLL then scroll = -25/25, scrollFrame:GetVerticalScrollRange() = 0
        -- then scrollFrame:SetVerticalScroll(0) and scrollFrame:SetVerticalScroll(scrollFrame:GetVerticalScrollRange()) ARE THE SAME
        if scroll <= 0 then
            scrollFrame:SetVerticalScroll(0)
        elseif scroll >= scrollFrame:GetVerticalScrollRange() then
            scrollFrame:SetVerticalScroll(scrollFrame:GetVerticalScrollRange())
        else
            scrollFrame:SetVerticalScroll(scroll)
        end
    end

    -- NOTE: this func should not be called before Show, or GetVerticalScrollRange will be incorrect.
    function scrollFrame:ScrollToBottom()
        scrollFrame:SetVerticalScroll(scrollFrame:GetVerticalScrollRange())
    end

    function scrollFrame:SetContentHeight(height, num, spacing)
        if num and spacing then
            content:SetHeight(num*height+(num-1)*spacing)
        else
            content:SetHeight(height)
        end
    end

    --[[ BUG: not reliable
    -- to remove/hide widgets "widget:SetParent(nil)" MUST be called!!!
    scrollFrame:SetScript("OnUpdate", function()
        -- set content height, check if it CAN SCROLL
        local x, y, w, h = content:GetBoundsRect()
        -- NOTE: if content is not IN SCREEN -> x,y<0 -> h==-y!
        if x > 0 and y > 0 then
            content:SetHeight(h)
        end
    end)
    ]]
    
    -- stores all widgets on content frame
    -- local autoWidthWidgets = {}

    function scrollFrame:ClearContent()
        for _, c in pairs({content:GetChildren()}) do
            c:SetParent(nil)  -- or it will show (OnUpdate)
            c:ClearAllPoints()
            c:Hide()
        end
        -- wipe(autoWidthWidgets)
        scrollFrame:ResetHeight()
    end

    function scrollFrame:Reset()
        scrollFrame:ResetScroll()
        scrollFrame:ClearContent()
    end
    
    -- function scrollFrame:SetWidgetAutoWidth(widget)
    -- 	table.insert(autoWidthWidgets, widget)
    -- end
    
    -- on width changed, make the same change to widgets
    scrollFrame:SetScript("OnSizeChanged", function()
        -- change widgets width (marked as auto width)
        -- for i = 1, #autoWidthWidgets do
        -- 	autoWidthWidgets[i]:SetWidth(scrollFrame:GetWidth())
        -- end

        -- update content width
        content:SetWidth(scrollFrame:GetWidth())
    end)

    -- check if it can scroll
    content:SetScript("OnSizeChanged", function()
        -- set ACCURATE scroll range
        -- scrollRange = content:GetHeight() - scrollFrame:GetHeight()

        -- set thumb height (%)
        local p = scrollFrame:GetHeight() / content:GetHeight()
        p = tonumber(string.format("%.3f", p))
        if p < 1 then -- can scroll
            scrollThumb:SetHeight(scrollbar:GetHeight()*p)
            -- space for scrollbar
            scrollFrame:SetPoint("BOTTOMRIGHT", parent, -7, bottom)
            scrollbar:Show()
        else
            scrollFrame:SetPoint("BOTTOMRIGHT", parent, 0, bottom)
            scrollbar:Hide()
            if scrollFrame:GetVerticalScroll() > 0 then scrollFrame:SetVerticalScroll(0) end
        end
    end)

    -- DO NOT USE OnScrollRangeChanged to check whether it can scroll.
    -- "invisible" widgets should be hidden, then the scroll range is NOT accurate!
    -- scrollFrame:SetScript("OnScrollRangeChanged", function(self, xOffset, yOffset) end)
    
    -- dragging and scrolling
    scrollThumb:SetScript("OnMouseDown", function(self, button)
        if button ~= 'LeftButton' then return end
        local offsetY = select(5, scrollThumb:GetPoint(1))
        local mouseY = select(2, GetCursorPosition())
        local uiScale = UIParent:GetEffectiveScale() -- https://wowpedia.fandom.com/wiki/API_GetCursorPosition
        local currentScroll = scrollFrame:GetVerticalScroll()
        self:SetScript("OnUpdate", function(self)
            --------------------- y offset before dragging + mouse offset
            local newOffsetY = offsetY + (select(2, GetCursorPosition()) - mouseY) / uiScale
            
            -- even scrollThumb:SetPoint is already done in OnVerticalScroll, but it's useful in some cases.
            if newOffsetY >= 0 then -- @top
                scrollThumb:SetPoint("TOP")
                newOffsetY = 0
            elseif (-newOffsetY) + scrollThumb:GetHeight() >= scrollbar:GetHeight() then -- @bottom
                scrollThumb:SetPoint("TOP", 0, -(scrollbar:GetHeight() - scrollThumb:GetHeight()))
                newOffsetY = -(scrollbar:GetHeight() - scrollThumb:GetHeight())
            else
                scrollThumb:SetPoint("TOP", 0, newOffsetY)
            end
            local vs = (-newOffsetY / (scrollbar:GetHeight()-scrollThumb:GetHeight())) * scrollFrame:GetVerticalScrollRange()
            scrollFrame:SetVerticalScroll(vs)
        end)
    end)

    scrollThumb:SetScript("OnMouseUp", function(self)
        self:SetScript("OnUpdate", nil)
    end)
    
    scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
        if scrollFrame:GetVerticalScrollRange() ~= 0 then
            local scrollP = scrollFrame:GetVerticalScroll()/scrollFrame:GetVerticalScrollRange()
            local yoffset = -((scrollbar:GetHeight()-scrollThumb:GetHeight())*scrollP)
            scrollThumb:SetPoint("TOP", 0, yoffset)
        end
    end)

    function scrollFrame:UpdateSize()
        content:GetScript("OnSizeChanged")(content)
        scrollFrame:GetScript("OnVerticalScroll")(scrollFrame)
        scrollFrame:VerticalScroll(0)
    end
    
    local step = 25
    function scrollFrame:SetScrollStep(s)
        step = s
    end
    
    -- enable mouse wheel scroll
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        if delta == 1 then -- scroll up
            scrollFrame:VerticalScroll(-step)
        elseif delta == -1 then -- scroll down
            scrollFrame:VerticalScroll(step)
        end
    end)
    
    return scrollFrame
end

------------------------------------------------
-- dropdown menu
------------------------------------------------
local listInit, list, highlightTexture
list = CreateFrame("Frame", addonName.."DropdownList", UIParent, "BackdropTemplate")
list:SetIgnoreParentScale(true)
-- addon:StylizeFrame(list, {0.115, 0.115, 0.115, 1})
list:Hide()

-- store created buttons
list.items = {}

-- highlight
highlightTexture = CreateFrame("Frame", nil, list, "BackdropTemplate")
-- highlightTexture:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
-- highlightTexture:SetBackdropBorderColor(unpack(accentColor.t))
highlightTexture:Hide()

list:SetScript("OnShow", function()
    list:SetScale(list.menu:GetEffectiveScale())
    list:SetFrameStrata(list.menu:GetFrameStrata())
    list:SetFrameLevel(77) -- top of its strata
end)
list:SetScript("OnHide", function() list:Hide() end)

-- close dropdown
function addon:RegisterForCloseDropdown(f)
    if f:GetObjectType() == "Button" or f:GetObjectType() == "CheckButton" then
        f:HookScript("OnClick", function()
            list:Hide()
        end)
    elseif f:GetObjectType() == "Slider" then
        f:HookScript("OnValueChanged", function()
            list:Hide()
        end)
    end
end

local function SetHighlightItem(i)
    if not i then
        highlightTexture:ClearAllPoints()
        highlightTexture:Hide()
    else
        highlightTexture:SetParent(list.items[i]) -- buttons show/hide automatically when scroll, so let highlightTexture to be the same
        highlightTexture:ClearAllPoints()
        highlightTexture:SetAllPoints(list.items[i])
        highlightTexture:Show()
    end
end

function addon:CreateDropdown(parent, width, dropdownType, isMini)
    local menu = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    P:Size(menu, width, 20)
    menu:EnableMouse(true)
    -- menu:SetFrameLevel(5)
    addon:StylizeFrame(menu, {0.115, 0.115, 0.115, 1})
    
    -- button: open/close menu list
    if isMini then
        menu.button = addon:CreateButton(menu, "", "transparent-accent", {18 ,18})
        menu.button:SetAllPoints(menu)
        menu.button:SetFrameLevel(menu:GetFrameLevel()+1)
        -- selected item
        menu.text = menu.button:CreateFontString(nil, "OVERLAY", font_name)
        menu.text:SetPoint("LEFT", P:Scale(1), 0)
        menu.text:SetPoint("RIGHT", P:Scale(-1), 0)
        menu.text:SetJustifyH("CENTER")
    else
        menu.button = addon:CreateButton(menu, "", "transparent-accent", {18 ,20})
        addon:StylizeFrame(menu.button, {0.115, 0.115, 0.115, 1})
        menu.button:SetPoint("TOPRIGHT")
        menu.button:SetFrameLevel(menu:GetFrameLevel()+1)
        menu.button:SetNormalTexture([[Interface\AddOns\Cell\Media\Icons\dropdown-normal]])
        menu.button:SetPushedTexture([[Interface\AddOns\Cell\Media\Icons\dropdown-pushed]])

        local disabledTexture = menu.button:CreateTexture(nil, "OVERLAY")
        disabledTexture:SetTexture([[Interface\AddOns\Cell\Media\Icons\dropdown-normal]])
        disabledTexture:SetVertexColor(0.4, 0.4, 0.4, 1)
        menu.button:SetDisabledTexture(disabledTexture)
        -- selected item
        menu.text = menu:CreateFontString(nil, "OVERLAY", font_name)
        menu.text:SetPoint("TOPLEFT", P:Scale(5), P:Scale(-1))
        menu.text:SetPoint("BOTTOMRIGHT", P:Scale(-18), P:Scale(1))
        menu.text:SetJustifyH("LEFT")
    end

    -- selected item
    menu.text:SetJustifyV("MIDDLE")
    menu.text:SetWordWrap(false)

    if dropdownType == "texture" then
        menu.texture = menu:CreateTexture(nil, "ARTWORK")
        menu.texture:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
        menu.texture:SetPoint("BOTTOMRIGHT", P:Scale(-18), P:Scale(1))
        menu.texture:SetVertexColor(1, 1, 1, 0.7)
    end
    
    -- keep all menu item buttons
    menu.items = {}

    -- index in items
    -- menu.selected
    
    function menu:SetSelected(text, value)
        local valid
        for i, item in pairs(menu.items) do
            if item.text == text then
                valid = true
                -- store index for list
                menu.selected = i
                menu.text:SetText(text)
                if dropdownType == "texture" then
                    menu.texture:SetTexture(value)
                elseif dropdownType == "font" then
                    menu.text:SetFont(value, 13+fontSizeOffset, "")
                end
                break
            end
        end
        if not valid then
            menu.selected = nil
            menu.text:SetText("")
        end
    end

    function menu:SetSelectedValue(value)
        for i, item in pairs(menu.items) do
            if item.value == value then
                menu.selected = i
                menu.text:SetText(item.text)
                break
            end
        end
    end

    function menu:GetSelected()
        if menu.selected then
            return menu.items[menu.selected].value or menu.items[menu.selected].text
        end
        return nil
    end

    function menu:SetSelectedItem(itemNum)
        local item = menu.items[itemNum]
        menu.text:SetText(item.text)
        menu.selected = itemNum
    end

    -- items = {
    -- 	{
    -- 		["text"] = (string),
    -- 		["value"] = (obj),
    -- 		["texture"] = (string),
    -- 		["onClick"] = (function)
    -- 	},
    -- }
    function menu:SetItems(items)
        menu.items = items
        menu.reloadRequired = true
    end

    function menu:AddItem(item)
        tinsert(menu.items, item)
        menu.reloadRequired = true
    end

    function menu:RemoveCurrentItem()
        tremove(menu.items, menu.selected)
        menu.reloadRequired = true
    end

    function menu:ClearItems()
        wipe(menu.items)
        menu.selected = nil
        menu.text:SetText("")
    end

    function menu:SetCurrentItem(item)
        menu.items[menu.selected] = item
        -- usually, update current item means to change its name (text) and func
        menu.text:SetText(item["text"])
        menu.reloadRequired = true
    end

    local function LoadItems()
        if not listInit then
            listInit = true
            addon:CreateScrollFrame(list)
            list.scrollFrame:SetScrollStep(18)
            addon:StylizeFrame(list, {0.115, 0.115, 0.115, 1})
            highlightTexture:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
            highlightTexture:SetBackdropBorderColor(unpack(accentColor.t))
        end

        -- hide highlight
        SetHighlightItem()
        -- hide all list items
        list.scrollFrame:Reset()

        -- load current dropdown
        for i, item in pairs(menu.items) do
            local b
            if not list.items[i] then
                -- init
                b = addon:CreateButton(list.scrollFrame.content, item.text, "transparent-accent", {18 ,18}, true) --! width is not important
                table.insert(list.items, b)

                -- texture
                b.texture = b:CreateTexture(nil, "ARTWORK")
                b.texture:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
                b.texture:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))
                b.texture:SetVertexColor(1, 1, 1, 0.7)
                b.texture:Hide()
            else
                b = list.items[i]
                b:SetText(item.text)
            end

            local fs = b:GetFontString()
            if isMini then
                fs:ClearAllPoints()
                fs:SetJustifyH("CENTER")
                fs:SetPoint("LEFT", 1, 0)
                fs:SetPoint("RIGHT", -1, 0)
            else
                fs:ClearAllPoints()
                fs:SetJustifyH("LEFT")
                fs:SetPoint("LEFT", 5, 0)
                fs:SetPoint("RIGHT", -5, 0)
            end

            b:SetEnabled(not item.disabled)

            -- texture
            if item.texture then
                b.texture:SetTexture(item.texture)
                b.texture:Show()
            else
                b.texture:Hide()
            end

            -- font
            local f, s = font:GetFont()
            if item.font then
                b:GetFontString():SetFont(item.font, s, "")
            else
                b:GetFontString():SetFont(f, s, "")
            end

            -- highlight
            if menu.selected == i then
                SetHighlightItem(i)
            end

            b:SetScript("OnClick", function()
                PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
                if dropdownType == "texture" then
                    menu:SetSelected(item.text, item.texture)
                elseif dropdownType == "font" then
                    menu:SetSelected(item.text, item.font)
                else
                    menu:SetSelected(item.text)
                end
                list:Hide()
                if item.onClick then item.onClick(item.text) end
            end)

            -- update point
            b:SetParent(list.scrollFrame.content)
            b:Show()
            if i == 1 then
                b:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
                b:SetPoint("TOPRIGHT", P:Scale(-1), P:Scale(-1))
            else
                b:SetPoint("TOPLEFT", list.items[i-1], "BOTTOMLEFT")
                b:SetPoint("TOPRIGHT", list.items[i-1], "BOTTOMRIGHT")
            end
        end

        -- update list size
        list.menu = menu -- menu's OnHide -> list:Hide
        list:ClearAllPoints()
        list:SetPoint("TOPLEFT", menu, "BOTTOMLEFT", 0, -2)
        
        if #menu.items == 0 then
            list:SetSize(menu:GetWidth(), P:Scale(5))
        elseif #menu.items <= 10 then
            list:SetSize(menu:GetWidth(), P:Scale(2) + #menu.items*P:Scale(18))
            list.scrollFrame:SetContentHeight(P:Scale(2) + #menu.items*P:Scale(18))
        else
            list:SetSize(menu:GetWidth(), P:Scale(2) + 10*P:Scale(18))
            -- update list scrollFrame
            list.scrollFrame:SetContentHeight(P:Scale(2) + #menu.items*P:Scale(18))
        end
    end

    function menu:SetEnabled(f)
        menu.button:SetEnabled(f)
        if f then
            menu.text:SetTextColor(1, 1, 1)
        else
            menu.text:SetTextColor(0.4, 0.4, 0.4)
        end
    end

    menu:SetScript("OnHide", function()
        if list.menu == menu then
            list:Hide()
        end
    end)
    
    -- scripts
    menu.button:HookScript("OnClick", function()
        if list.menu ~= menu then -- list shown by other dropdown
            LoadItems()
            list:Show()

        elseif list:IsShown() then -- list showing by this, hide it
            list:Hide()

        else
            if menu.reloadRequired then
                LoadItems()
                menu.reloadRequired = false
            else
                -- update highlight
                if menu.selected then
                    SetHighlightItem(menu.selected)
                end
            end
            list:Show()
        end
    end)
    
    return menu
end

-----------------------------------------
-- binding button
-----------------------------------------
local function GetModifier()
    local modifier = "" -- "shift-", "ctrl-", "alt-", "ctrl-shift-", "alt-shift-", "alt-ctrl-", "alt-ctrl-shift-"
    local alt, ctrl, shift = IsAltKeyDown(), IsControlKeyDown(), IsShiftKeyDown()
    if alt and ctrl and shift then
        modifier = "alt-ctrl-shift-"
    elseif alt and ctrl then
        modifier = "alt-ctrl-"
    elseif alt and shift then
        modifier = "alt-shift-"
    elseif ctrl and shift then
        modifier = "ctrl-shift-"
    elseif alt then
        modifier = "alt-"
    elseif ctrl then
        modifier = "ctrl-"
    elseif shift then
        modifier = "shift-"
    end
    return modifier
end

function addon:CreateBindingButton(parent, width)
    if not parent.bindingButton then
        parent.bindingButton = addon:CreateFrame("CellClickCastings_BindingButton", parent, 50, 20)
        parent.bindingButton:SetFrameStrata("TOOLTIP")
        parent.bindingButton:Hide()
        tinsert(UISpecialFrames, parent.bindingButton:GetName())
        addon:StylizeFrame(parent.bindingButton, {0.1, 0.1, 0.1, 1}, {accentColor.t[1], accentColor.t[2], accentColor.t[3]})

        parent.bindingButton.close = addon:CreateButton(parent.bindingButton, "×", "red", {18, 18}, true, true, "CELL_FONT_SPECIAL", "CELL_FONT_SPECIAL")
        parent.bindingButton.close:SetPoint("TOPRIGHT", -1, -1)
        parent.bindingButton.close:SetScript("OnClick", function()
            parent.bindingButton:Hide()
        end)
        
        parent.bindingButton.text = parent.bindingButton:CreateFontString(nil, "OVERLAY", font_name)
        parent.bindingButton.text:SetPoint("LEFT")
        parent.bindingButton.text:SetPoint("RIGHT", parent.bindingButton.close, "LEFT")
        parent.bindingButton.text:SetText(L["Press Key to Bind"])

        parent.bindingButton:SetScript("OnHide", function()
            parent.bindingButton:Hide()
        end)

        parent.bindingButton:EnableMouse(true)
        parent.bindingButton:EnableMouseWheel(true)
        parent.bindingButton:EnableKeyboard(true)

        -- mouse
        parent.bindingButton:SetScript("OnMouseDown", function(self, key)
            parent.bindingButton:Hide()
            if key == "LeftButton" then
                key = "Left"
            elseif key == "RightButton" then
                key = "Right"
            elseif key == "MiddleButton" then
                key = "Middle"
            end

            if parent.bindingButton.func then parent.bindingButton.func(GetModifier(), key) end
        end)
        
        -- mouse wheel
        parent.bindingButton:SetScript("OnMouseWheel", function(self, key)
            parent.bindingButton:Hide()
            if parent.bindingButton.func then parent.bindingButton.func(GetModifier(), (key==1) and "ScrollUp" or "ScrollDown") end
        end)
        
        -- keyboard
        parent.bindingButton:SetScript("OnKeyDown", function(self, key)
            if key == "ESCAPE" or key == "LALT" or key == "RALT" or key == "LCTRL" or key == "RCTRL" or key == "LSHIFT" or key ==  "RSHIFT" then return end
            parent.bindingButton:Hide()
            if parent.bindingButton.func then parent.bindingButton.func(GetModifier(), key) end
        end)
        
        function parent.bindingButton:SetFunc(func)
            parent.bindingButton.func = func
        end
    end

    parent.bindingButton:ClearAllPoints()
    P:Width(parent.bindingButton, width)

    return parent.bindingButton
end

-----------------------------------------
-- binding list button
-----------------------------------------
local function CreateGrid(parent, text, width)
    local grid = CreateFrame("Button", nil, parent, "BackdropTemplate")
    grid:SetFrameLevel(6)
    grid:SetSize(width, P:Scale(20))
    grid:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    grid:SetBackdropColor(0, 0, 0, 0) 
    grid:SetBackdropBorderColor(0, 0, 0, 1)

    -- to avoid SetText("") -> GetFontString() == nil
    grid.text = grid:CreateFontString(nil, "OVERLAY", font_name)
    grid.text:SetWordWrap(false)
    grid.text:SetJustifyH("LEFT")
    grid.text:SetPoint("LEFT", P:Scale(5), 0)
    grid.text:SetPoint("RIGHT", P:Scale(-5), 0)
    grid.text:SetText(text)

    function grid:SetText(s)
        grid.text:SetText(s)
    end

    function grid:GetText()
        return grid.text:GetText()
    end

    function grid:IsTruncated()
        return grid.text:IsTruncated()
    end

    grid:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    grid:SetScript("OnEnter", function() 
        grid:SetBackdropColor(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.15)
        parent:Highlight()
    end)

    grid:SetScript("OnLeave", function()
        grid:SetBackdropColor(0, 0, 0, 0)
        parent:Unhighlight()
    end)

    return grid
end

function addon:CreateBindingListButton(parent, modifier, bindKey, bindType, bindAction)
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetFrameLevel(5)
    P:Size(b, 100, 20)
    b:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    b:SetBackdropColor(0.115, 0.115, 0.115, 1) 
    b:SetBackdropBorderColor(0, 0, 0, 1)

    function b:Highlight()
        b:SetBackdropColor(accentColor.t[1], accentColor.t[2], accentColor.t[3], 0.1)
    end

    function b:Unhighlight()
        b:SetBackdropColor(0.115, 0.115, 0.115, 1)
    end

    local keyGrid = CreateGrid(b, modifier..bindKey, 130)
    b.keyGrid = keyGrid
    keyGrid:SetPoint("BOTTOMLEFT")

    local typeGrid = CreateGrid(b, bindType, 70)
    b.typeGrid = typeGrid
    typeGrid:SetPoint("BOTTOMLEFT", keyGrid, "BOTTOMRIGHT", P:Scale(-1), 0)

    local actionGrid = CreateGrid(b, bindAction, 100)
    b.actionGrid = actionGrid
    actionGrid:SetPoint("BOTTOMLEFT", typeGrid, "BOTTOMRIGHT", P:Scale(-1), 0)
    actionGrid:SetPoint("BOTTOMRIGHT")

    actionGrid:HookScript("OnEnter", function()
        if actionGrid:IsTruncated() then
            CellTooltip:SetOwner(actionGrid, "ANCHOR_TOPLEFT", 0, P:Scale(1))
            CellTooltip:AddLine(L["Action"])
            CellTooltip:AddLine("|cffffffff" .. actionGrid:GetText())
            CellTooltip:Show()
        end
    end)
    actionGrid:HookScript("OnLeave", function()
        CellTooltip:Hide()
    end)

    -- spell icon
    local spellIconBg = actionGrid:CreateTexture(nil, "BORDER")
    P:Size(spellIconBg, 16, 16)
    spellIconBg:SetPoint("TOPLEFT", P:Scale(2), P:Scale(-2))
    spellIconBg:SetColorTexture(0, 0, 0, 1)
    spellIconBg:Hide()

    local spellIcon = actionGrid:CreateTexture(nil, "OVERLAY")
    spellIcon:SetPoint("TOPLEFT", spellIconBg, P:Scale(1), P:Scale(-1))
    spellIcon:SetPoint("BOTTOMRIGHT", spellIconBg, P:Scale(-1), P:Scale(1))
    spellIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    spellIcon:Hide()

    function b:ShowSpellIcon(spellName)
        spellIcon:SetTexture(GetSpellTexture(spellName) or 134400)
        spellIconBg:Show()
        spellIcon:Show()
        -- actionGrid.text:ClearAllPoints()
        actionGrid.text:SetPoint("LEFT", spellIconBg, "RIGHT", P:Scale(2), 0)
        -- actionGrid.text:SetPoint("RIGHT", P:Scale(-5), 0)
    end

    function b:HideSpellIcon()
        spellIconBg:Hide()
        spellIcon:Hide()
        -- actionGrid.text:ClearAllPoints()
        actionGrid.text:SetPoint("LEFT", P:Scale(5), 0)
        -- actionGrid.text:SetPoint("RIGHT", P:Scale(-5), 0)
    end

    function b:SetBorderColor(...)
        keyGrid:SetBackdropBorderColor(...)
        typeGrid:SetBackdropBorderColor(...)
        actionGrid:SetBackdropBorderColor(...)
    end

    function b:SetChanged(isChanged)
        if isChanged then
            b:SetBorderColor(accentColor.t[1], accentColor.t[2], accentColor.t[3], 1)
        else
            b:SetBorderColor(0, 0, 0, 1)
        end
    end

    return b
end

-----------------------------------------
-- receiving frame
-----------------------------------------
function addon:CreateReceivingFrame(parent)
    local f = CreateFrame("Frame", "CellReceivingFrame", parent, "BackdropTemplate")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:SetUserPlaced(true)
    f:RegisterForDrag("LeftButton")
    f:SetFrameStrata("DIALOG")
    f:SetFrameLevel(277)
    f:SetClampedToScreen(true)
    P:Size(f, 249, 135)
    f:SetPoint("TOPRIGHT", UIParent, "CENTER")
    addon:StylizeFrame(f)

    f:SetScript("OnDragStart", function() f:StartMoving() end)
    f:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)

    -- labels
    local typeLabel = f:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    typeLabel:SetPoint("TOPLEFT", 10, -10)
    typeLabel:SetText(L["Type: "])

    local nameLabel = f:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    nameLabel:SetPoint("LEFT", 10, 0)
    nameLabel:SetText(L["Name: "])

    local fromLabel = f:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    fromLabel:SetPoint("LEFT", 10, 0)
    fromLabel:SetText(L["From: "])

    local dataLabel = f:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    dataLabel:SetPoint("LEFT", 10, 0)
    dataLabel:Hide()

    -- texts
    local typeText = f:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    typeText:SetPoint("TOPLEFT", typeLabel, "TOPRIGHT")
    typeText:SetPoint("RIGHT", -10, 0)
    typeText:SetJustifyH("LEFT")

    nameLabel:SetPoint("TOP", typeText, "BOTTOM", 0, -10)

    local nameText = f:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    nameText:SetPoint("TOPLEFT", nameLabel, "TOPRIGHT")
    nameText:SetPoint("RIGHT", -10, 0)
    nameText:SetJustifyH("LEFT")
    nameText:SetWordWrap(true)

    fromLabel:SetPoint("TOP", nameText, "BOTTOM", 0, -10)
    
    local fromText = f:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    fromText:SetPoint("TOPLEFT", fromLabel, "TOPRIGHT")
    fromText:SetPoint("RIGHT", -10, 0)
    fromText:SetJustifyH("LEFT")
    fromText:SetWordWrap(true)

    dataLabel:SetPoint("TOP", fromText, "BOTTOM", 0, -10)

    local dataText = f:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    dataText:SetPoint("TOPLEFT", dataLabel, "TOPRIGHT")
    dataText:SetPoint("RIGHT", -10, 0)
    dataText:SetJustifyH("LEFT")
    dataText:SetWordWrap(true)
    dataText:Hide()

    -- error
    local infoMsg = f:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    infoMsg:SetJustifyH("LEFT")
    infoMsg:SetTextColor(unpack(colors.firebrick.t))
    infoMsg:SetWordWrap(true)
    infoMsg:Hide()

    function infoMsg:SetMsg(msg, anchorTo)
        infoMsg:SetText(msg)
        infoMsg:ClearAllPoints()
        infoMsg:SetPoint("LEFT", 10, 0)
        infoMsg:SetPoint("RIGHT", -10, 0)
        infoMsg:SetPoint("TOP", anchorTo, "BOTTOM", 0, -10)
    end

    -- buttons
    local requestBtn = addon:CreateButton(f, L["Request"], "green", {125, 20})
    requestBtn:SetPoint("BOTTOMLEFT")

    local importBtn = addon:CreateButton(f, L["Import"], "green", {125, 20})
    importBtn:SetPoint("BOTTOMLEFT")
    
    local cancelBtn = addon:CreateButton(f, L["Cancel"], "red", {125, 20})
    cancelBtn:SetPoint("BOTTOMLEFT", importBtn, "BOTTOMRIGHT", -1, 0)
    cancelBtn:SetPoint("BOTTOMRIGHT")

    -- bar
    local progressBar = addon:CreateStatusBar("CellReceivingFrameBar", f, 198, 18, 0, true, nil, true, "Interface\\AddOns\\Cell\\Media\\statusbar.tga", {0.7, 0.7, 0, 1})
    progressBar:SetPoint("BOTTOMLEFT", 1, 1)
    progressBar:SetPoint("BOTTOMRIGHT", cancelBtn, "BOTTOMLEFT")
    progressBar:Hide()

    function f:ShowFrame(type, playerName, name1, name2)
        P:Size(f, 249, 20) -- reset size
        typeLabel:Hide()
        nameLabel:Hide()
        fromLabel:Hide()
        typeText:Hide()
        nameText:Hide()
        fromText:Hide()

        typeText:SetText(L[type])
        if name2 then
            nameText:SetText(name2.." ("..name1..")")
        else
            nameText:SetText(name1)
        end
        fromText:SetText(playerName)

        local lines = typeText:GetNumLines() + nameText:GetNumLines() + fromText:GetNumLines()
        addon:ChangeSizeWithAnimation(f, 249, 40 + lines*math.ceil(typeLabel:GetStringHeight()*1.4), 7, nil, function()
            typeLabel:Show()
            nameLabel:Show()
            fromLabel:Show()
            typeText:Show()
            nameText:Show()
            fromText:Show()
        end)

        -- NOTE: you cannot send to yourself
        requestBtn:SetEnabled(playerName ~= Cell.vars.playerNameFull)
        importBtn:Hide()
        dataLabel:Hide()
        dataText:Hide()
        infoMsg:Hide()
        requestBtn:Show()

        f:Show()
    end

    local timeout
    function f:SetOnRequest(func)
        requestBtn:SetScript("OnClick", function(self)
            requestBtn:Hide()
            progressBar:SetValue(0)
            progressBar:Show()
            addon:ChangeSizeWithAnimation(importBtn, 200, 20, 7)
            func(self)
            
            infoMsg:Hide()
            -- NOTE: timeout in 10 sec if can't receive any data
            timeout = C_Timer.NewTimer(10, function()
                if f:IsShown() and progressBar:GetValue() == 0 then
                    infoMsg:SetMsg(L["To transfer across realm, you need to be in the same group"], fromText)
                    addon:ChangeSizeWithAnimation(f, 249, f.height+15+math.ceil(infoMsg:GetStringHeight()), 7, nil, function()
                        infoMsg:Show()
                    end)
                end
            end)
        end)
    end

    function f:SetOnCancel(func)
        cancelBtn:SetScript("OnClick", function(self)
            f:Hide()
            progressBar:Hide()
            importBtn:SetWidth(125)
            func(self)
        end)
    end
    
    function f:ShowProgress(done, total)
        progressBar:SetMaxValue(total)
        progressBar:SetSmoothedValue(done)
    end

    function f:ShowImport(status, received, func)
        if timeout then
            timeout:Cancel()
            timeout = nil
        end
        addon:ChangeSizeWithAnimation(importBtn, 125, 20, 7)
        progressBar:Hide()
        importBtn:Show()
        importBtn:SetEnabled(false)

        if status then
            if received["type"] == "Debuffs" then
                local isCompatible = type(received["version"]) == "number" and received["version"] >= Cell.MIN_DEBUFFS_VERSION
                
                F:Debug("|cffFFDAB9RECEIVED DEBUFFS:|r ", received["instanceId"], received["bossId"], received["data"])
                local builtIn, custom = F:CalcRaidDebuffs(received["instanceId"], received["bossId"], received["data"])

                dataLabel:SetText(L["Debuffs"] .. ": ")
                dataText:SetText("|cff90EE90"..builtIn.." "..L["built-in(s)"].."|r, |cffFFB5C5"..custom.." "..L["custom(s)"].."|r")

                importBtn:SetScript("OnClick", function()
                    F:UpdateRaidDebuffs(received["instanceId"], received["bossId"], received["data"], nameText:GetText())
                    F:ShowInstanceDebuffs(received["instanceId"], received["bossId"])
                    f:Hide()
                end)
                
                C_Timer.After(0.5, function()
                    if isCompatible then
                        infoMsg:SetMsg(L["This will overwrite your debuffs"], dataText)
                    else
                        infoMsg:SetMsg(L["Incompatible Version"], dataText)
                    end
                    addon:ChangeSizeWithAnimation(f, 249, f.height+15+math.ceil(dataText:GetStringHeight()+infoMsg:GetStringHeight()), 7, nil, function()
                        dataLabel:Show()
                        dataText:Show()
                        infoMsg:Show()
                        importBtn:SetEnabled(isCompatible)
                        if func then func() end
                    end)
                end)

            elseif received["type"] == "Layout" then
                local isCompatible = type(received["version"]) == "number" and received["version"] >= Cell.MIN_LAYOUTS_VERSION

                F:Debug("|cffFFDAB9RECEIVED LAYOUT:|r ", received["name"], received["data"])

                importBtn:SetScript("OnClick", function()
                    -- check layout name
                    local layoutName = received["name"]
                    if CellDB["layouts"][layoutName] then
                        local i = 1
                        while true do
                            if not CellDB["layouts"][layoutName.." "..i] then
                                layoutName = layoutName.." "..i
                                break
                            end
                            i = i + 1
                        end
                    end
                    -- save
                    CellDB["layouts"][layoutName] = received["data"]
                    F:ShowLayout(layoutName)
                    f:Hide()
                end)

                C_Timer.After(0.5, function()
                    if isCompatible then
                        infoMsg:SetMsg(L["It will be renamed if this layout name already exists"], fromText)
                    else
                        infoMsg:SetMsg(L["Incompatible Version"], fromText)
                    end
                    addon:ChangeSizeWithAnimation(f, 249, f.height+15+math.ceil(infoMsg:GetStringHeight()), 7, nil, function()
                        dataLabel:Show()
                        dataText:Show()
                        infoMsg:Show()
                        importBtn:SetEnabled(isCompatible)
                        if func then func() end
                    end)
                end)
            end
        else
            infoMsg:SetMsg(L["Data transfer failed..."], fromText)
            addon:ChangeSizeWithAnimation(f, 249, f.height+15+math.ceil(infoMsg:GetStringHeight()), 7, nil, function()
                infoMsg:Show()
                if func then func() end
            end)
        end
    end

    return f
end