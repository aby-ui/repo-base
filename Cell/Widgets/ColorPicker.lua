local addonName, addon = ...
local L = addon.L
local F = addon.funcs
local P = addon.pixelPerfectFuncs

local colorPicker
local current, original, hueSaturationBG, hueSaturation, brightness, alpha, picker
local rEB, gEB, bEB, aEB, h_EB, s_EB, b_EB, hexEB
local confirmBtn, cancelBtn 

local Callback

local oR, oG, oB, oA
local H, S, B, A

-------------------------------------------------
-- update functions
-------------------------------------------------
local function UpdateColor_RGBA(r, g, b, a)
    -- update current & original
    current:SetColor(r, g, b, a)
    
    r, g, b = math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)

    -- update editboxes
    rEB:SetText(r)
    gEB:SetText(g)
    bEB:SetText(b)
    aEB:SetText(math.floor(a * 100))
    hexEB:SetText(F:ConvertRGBToHEX(r, g, b))
end

local function UpdateColor_HSBA(h, s, b, a, updateBrightness, updatePickers)
    h_EB:SetText(math.floor(h))
    s_EB:SetText(math.floor(s * 100))
    b_EB:SetText(math.floor(b * 100))

    if updateBrightness then
        local _r, _g, _b = F:ConvertHSBToRGB(h, s, 1)
        if addon.isRetail then
            brightness.tex:SetGradient("VERTICAL", CreateColor(0, 0, 0, 1), CreateColor(_r, _g, _b, 1))
        else
            brightness.tex:SetGradient("VERTICAL", 0, 0, 0, _r, _g, _b)
        end
    end

    if updatePickers then
        picker:SetPoint("CENTER", hueSaturation, "BOTTOMLEFT", H/360*hueSaturation:GetWidth(), S*hueSaturation:GetHeight())
        brightness:SetValue(1-B)
        alpha:SetValue(1-a)
    end
end

local function UpdateAll(use, v1, v2, v3, a, updateBrightness, updatePickers)
    if use == "rgb" then
        UpdateColor_RGBA(v1, v2, v3, a)
        local h, s, b = F:ConvertRGBToHSB(v1, v2, v3)
        UpdateColor_HSBA(h, s, b, a, updateBrightness, updatePickers)
        if Callback then Callback(v1, v2, v3, a) end
    elseif use == "hsb" then
        UpdateColor_HSBA(v1, v2, v3, a, updateBrightness, updatePickers)
        local r, g, b = F:ConvertHSBToRGB(v1, v2, v3)
        UpdateColor_RGBA(r, g, b, a)
        if Callback then Callback(r, g, b, a) end
    end
end

-------------------------------------------------
-- create color picker
-------------------------------------------------
local function CreateEB(label, width, height, isNumeric, group)
    local eb = addon:CreateEditBox(colorPicker, width, height, false, false, isNumeric)
    eb.label = eb:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    eb.label:SetPoint("BOTTOMLEFT", eb, "TOPLEFT", 0, 1)
    eb.label:SetText(label)

    eb:SetScript("OnEditFocusGained", function()
        eb:HighlightText()
        eb.oldText = eb:GetText()
    end)
    
    eb:SetScript("OnEditFocusLost", function()
        eb:HighlightText(0, 0)
        if eb:GetText() == "" then
            eb:SetText(eb.oldText)
        end
    end)

    eb:SetScript("OnEnterPressed", function()
        if isNumeric then
            if group == "rgb" then
                if rEB:GetNumber() > 255 then
                    rEB:SetText(255)
                end
                if gEB:GetNumber() > 255 then
                    gEB:SetText(255)
                end
                if bEB:GetNumber() > 255 then
                    bEB:SetText(255)
                end

                local r, g, b = F:ConvertRGB(rEB:GetNumber(), gEB:GetNumber(), bEB:GetNumber())
                H, S, B = F:ConvertRGBToHSB(r, g, b)
                UpdateAll("rgb", r, g, b, A, true, true)

            elseif group == "hsb" then
                if h_EB:GetNumber() > 360 then
                    h_EB:SetText(360)
                end
                if s_EB:GetNumber() > 100 then
                    s_EB:SetText(100)
                end
                if b_EB:GetNumber() > 100 then
                    b_EB:SetText(100)
                end

                H, S, B = h_EB:GetNumber(), s_EB:GetNumber()/100, b_EB:GetNumber()/100
                UpdateAll("hsb", H, S, B, A, true, true)

            else -- alpha
                if aEB:GetNumber() > 100 then
                    aEB:SetText(100)
                end
                A = aEB:GetNumber()/100

                alpha:SetValue(1-A)
                UpdateAll("hsb", H, S, B, A)
            end
            
        else -- hex
            local text = strtrim(hexEB:GetText())
            -- print(text, hexEB.oldText)
            if strlen(text) ~= 6 or not strmatch(text, "^[0-9a-fA-F]+$") then
                hexEB:SetText(hexEB.oldText)
            end

            local r, g, b = F:ConvertRGB(F:ConvertHEXToRGB(hexEB:GetText()))
            H, S, B = F:ConvertRGBToHSB(r, g, b)
            UpdateAll("rgb", r, g, b, A, true, true)
        end

        eb:ClearFocus()
    end)

    return eb
end

local function CreateColorPicker()
    local name = addonName.."ColorPicker"

    colorPicker = addon:CreateMovableFrame(_G.COLOR_PICKER, name, 216, 295, "DIALOG", 1, true)
    colorPicker:SetFrameLevel(777)
    colorPicker:SetIgnoreParentScale(true)
    colorPicker:SetPoint("CENTER")
    colorPicker.header.closeBtn:Hide()

    P:SetEffectiveScale(colorPicker)

    --------------------------------------------------
    -- current
    --------------------------------------------------
    current = CreateFrame("Frame", name.."Current", colorPicker, "BackdropTemplate")
    addon:StylizeFrame(current)
    P:Size(current, 97, 27)
    current:SetPoint("TOPLEFT", 7, -7)

    current.solid = current:CreateTexture(nil, "ARTWORK")
    current.solid:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
    current.solid:SetPoint("BOTTOMRIGHT", current, "BOTTOMLEFT", current:GetWidth()/2, P:Scale(1))

    current.alpha = current:CreateTexture(nil, "ARTWORK")
    current.alpha:SetPoint("TOPLEFT", current.solid, "TOPRIGHT")
    current.alpha:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))
    
    function current:SetColor(r, g, b, a)
        current.solid:SetColorTexture(r, g, b)
        current.alpha:SetColorTexture(r, g, b, a)
    end
    
    --------------------------------------------------
    -- original
    --------------------------------------------------
    original = CreateFrame("Frame", name.."Original", colorPicker, "BackdropTemplate")
    addon:StylizeFrame(original)
    P:Size(original, 97, 27)
    original:SetPoint("TOPRIGHT", -7, -7)

    original.solid = original:CreateTexture(nil, "ARTWORK")
    original.solid:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
    original.solid:SetPoint("BOTTOMRIGHT", original, "BOTTOMLEFT", original:GetWidth()/2, P:Scale(1))

    original.alpha = original:CreateTexture(nil, "ARTWORK")
    original.alpha:SetPoint("TOPLEFT", original.solid, "TOPRIGHT")
    original.alpha:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))
    
    function original:SetColor(r, g, b, a)
        original.solid:SetColorTexture(r, g, b)
        original.alpha:SetColorTexture(r, g, b, a)
    end

    --------------------------------------------------
    -- hue, saturation
    --------------------------------------------------
    hueSaturationBG = CreateFrame("Frame", name.."HueSaturation", colorPicker, "BackdropTemplate")
    addon:StylizeFrame(hueSaturationBG)
    P:Size(hueSaturationBG, 130, 130)
    hueSaturationBG:SetPoint("TOPLEFT", current, "BOTTOMLEFT", 0, -7)
    
    hueSaturation = CreateFrame("Frame", nil, hueSaturationBG)
    hueSaturation:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
    hueSaturation:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))

    -- fill color
    local sectionSize = hueSaturation:GetWidth() / 6
    local color = {
        { r=1, g=0, b=0 },    -- Red
        { r=1, g=1, b=0 },    -- Yellow
        { r=0, g=1, b=0 },    -- Green
        { r=0, g=1, b=1 },    -- Cyan
        { r=0, g=0, b=1 },    -- Blue
        { r=1, g=0, b=1 },    -- Purple
        { r=1, g=0, b=0 },    -- back to Red
    }
    for i = 1, 6 do
        hueSaturation[i] = hueSaturation:CreateTexture(name.."HS_Gradient"..i, "ARTWORK", nil, 0)
        hueSaturation[i]:SetTexture("Interface\\Buttons\\WHITE8x8")
        -- hueSaturation[i]:SetColorTexture(1, 1, 1, 1)
        -- hueSaturation[i]:SetVertexColor(1, 1, 1, 1)
        if addon.isRetail then
            hueSaturation[i]:SetGradient("HORIZONTAL", CreateColor(color[i].r, color[i].g, color[i].b, 1), CreateColor(color[i+1].r, color[i+1].g, color[i+1].b, 1))
        else
            hueSaturation[i]:SetGradient("HORIZONTAL", color[i].r, color[i].g, color[i].b, color[i+1].r, color[i+1].g, color[i+1].b)
        end

        -- width
        hueSaturation[i]:SetWidth(sectionSize)

        -- point
        if i == 1 then
            hueSaturation[i]:SetPoint("TOPLEFT")
        else
            hueSaturation[i]:SetPoint("TOPLEFT", hueSaturation[i-1], "TOPRIGHT")
        end
        hueSaturation[i]:SetPoint("BOTTOM")
    end

    -- add saturation
    local saturation = hueSaturation:CreateTexture(name.."HS_Saturation", "ARTWORK", nil, 1)
    saturation:SetBlendMode("BLEND")
    saturation:SetTexture("Interface\\Buttons\\WHITE8x8")
    if addon.isRetail then
        saturation:SetGradient("VERTICAL", CreateColor(1, 1, 1, 1), CreateColor(1, 1, 1, 0))
    else
        saturation:SetGradientAlpha("VERTICAL", 1, 1, 1, 1, 1, 1, 1, 0)
    end
    saturation:SetAllPoints(hueSaturation)

    --------------------------------------------------
    -- brightness
    --------------------------------------------------
    brightness = CreateFrame("Slider", nil, colorPicker, "BackdropTemplate")
    addon:StylizeFrame(brightness)
    brightness:SetValueStep(0.01)
    brightness:SetMinMaxValues(0, 1)
    brightness:SetObeyStepOnDrag(true)
    brightness:SetOrientation("VERTICAL")
    P:Size(brightness, 17, 130)
    brightness:SetPoint("TOPLEFT", hueSaturation, "TOPRIGHT", 15, 0)

    brightness:SetScript("OnValueChanged", function(self, value, userChanged)
        if not userChanged then return end
        B = 1 - value

        if brightness.prev == B then return end
        brightness.prev = B

        -- update
        UpdateAll("hsb", H, S, B, A)
    end)

    brightness.tex = brightness:CreateTexture(nil, "ARTWORK")
    brightness.tex:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
    brightness.tex:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))
    brightness.tex:SetTexture("Interface\\Buttons\\WHITE8x8")

    brightness.thumb1 = brightness:CreateTexture(nil, "ARTWORK")
    -- brightness.thumb1:SetColorTexture(0, 1, 0, 1)
    P:Size(brightness.thumb1, 17, 1)
    brightness:SetThumbTexture(brightness.thumb1)

    brightness.thumb2 = brightness:CreateTexture(nil, "ARTWORK")
    brightness.thumb2:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\thumb.tga")
    P:Size(brightness.thumb2, 16, 16)
    brightness.thumb2:SetPoint("LEFT", brightness.thumb1, "RIGHT", -5, 0)

    --------------------------------------------------
    -- alpha
    --------------------------------------------------
    alpha = CreateFrame("Slider", nil, colorPicker, "BackdropTemplate")
    addon:StylizeFrame(alpha)
    alpha:SetValueStep(0.01)
    alpha:SetMinMaxValues(0, 1)
    alpha:SetObeyStepOnDrag(true)
    alpha:SetOrientation("VERTICAL")
    P:Size(alpha, 17, 130)
    alpha:SetPoint("TOPLEFT", brightness, "TOPRIGHT", 15, 0)

    alpha:SetScript("OnEnable", function()
        alpha:SetAlpha(1)
        alpha.thumb2:SetVertexColor(1, 1, 1, 1)
    end)
    alpha:SetScript("OnDisable", function()
        alpha:SetAlpha(0.2)
        alpha.thumb2:SetVertexColor(0.2, 0.2, 0.2, 1)
    end)
    alpha:SetScript("OnValueChanged", function(self, value, userChanged)
        if not userChanged then return end
        A = 1 - value

        if alpha.prev == A then return end
        alpha.prev = A

        -- update
        UpdateAll("hsb", H, S, B, A)
    end)

    alpha.tex = alpha:CreateTexture(nil, "ARTWORK")
    alpha.tex:SetPoint("TOPLEFT", P:Scale(1), P:Scale(-1))
    alpha.tex:SetPoint("BOTTOMRIGHT", P:Scale(-1), P:Scale(1))
    alpha.tex:SetTexture("Interface\\Buttons\\WHITE8x8")
    if addon.isRetail then
        alpha.tex:SetGradient("VERTICAL", CreateColor(0, 0, 0, 1), CreateColor(1, 1, 1, 1))
    else
        alpha.tex:SetGradient("VERTICAL", 0, 0, 0, 1, 1, 1)
    end

    alpha.thumb1 = alpha:CreateTexture(nil, "ARTWORK")
    P:Size(alpha.thumb1, 17, 1)
    alpha:SetThumbTexture(alpha.thumb1)

    alpha.thumb2 = brightness:CreateTexture(nil, "ARTWORK")
    alpha.thumb2:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\thumb.tga")
    P:Size(alpha.thumb2, 16, 16)
    alpha.thumb2:SetPoint("LEFT", alpha.thumb1, "RIGHT", -5, 0)

    --------------------------------------------------
    -- picker
    --------------------------------------------------
    picker = CreateFrame("Frame", name.."HSPicker", hueSaturation, "BackdropTemplate")
    P:Size(picker, 10, 10)
    picker:SetPoint("CENTER", hueSaturation, "BOTTOMLEFT")
    
    picker.tex = picker:CreateTexture(nil, "ARTWORK")
    picker.tex:SetAllPoints(picker)
    picker.tex:SetTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
    picker.tex:SetTexCoord(0, 0.15625, 0, 0.625)

    picker:EnableMouse(true)
    picker:SetMovable(true)

    function picker:StartMoving(x, y, mouseX, mouseY)
        local scale = P:GetEffectiveScale()
        self:SetScript("OnUpdate", function(self)
            local newMouseX, newMouseY = GetCursorPosition()

            local newX = x + (newMouseX - mouseX) / scale
            local newY = y + (newMouseY - mouseY) / scale
            
            if newX < 0 then -- left
                newX = 0
            elseif newX > hueSaturation:GetWidth() then -- right
                newX = hueSaturation:GetWidth()
            end
    
            if newY < 0 then -- top
                newY = 0
            elseif newY > hueSaturation:GetHeight() then
                newY = hueSaturation:GetHeight()
            end
    
            picker:SetPoint("CENTER", hueSaturation, "BOTTOMLEFT", newX, newY)

            -- update HSV
            H = (newX / hueSaturation:GetWidth()) * 360
            S = newY / hueSaturation:GetHeight()

            -- update
            UpdateAll("hsb", H, S, B, A, true)
        end)
    end

    picker:SetScript("OnMouseDown", function(self, button)
        if button ~= 'LeftButton' then return end
        local x, y = select(4, picker:GetPoint(1))
        local mouseX, mouseY = GetCursorPosition()

        picker:StartMoving(x, y, mouseX, mouseY)
    end)

    picker:SetScript("OnMouseUp", function(self)
        self:SetScript("OnUpdate", nil)
    end)

    -- click & drag
    hueSaturation:SetScript("OnMouseDown", function(self, button)
        if button ~= 'LeftButton' then return end
        local hueSaturationX, hueSaturationY = hueSaturation:GetLeft(), hueSaturation:GetBottom()
        local mouseX, mouseY = GetCursorPosition()
        
        local scale = P:GetEffectiveScale()
        mouseX, mouseY = mouseX/scale, mouseY/scale
        
        -- start dragging
        local x, y = select(4, picker:GetPoint(1))
        picker:StartMoving(mouseX/scale-hueSaturationX, mouseY/scale-hueSaturationY, mouseX, mouseY)
    end)

    hueSaturation:SetScript("OnMouseUp", function(self, button)
        picker:SetScript("OnUpdate", nil)
    end)

    --------------------------------------------------
    -- editboxes
    --------------------------------------------------
    -- red
    rEB = CreateEB("R", 40, 20, true, "rgb")
    rEB:SetPoint("TOPLEFT", hueSaturationBG, "BOTTOMLEFT", 0, -25)

    -- green
    gEB = CreateEB("G", 40, 20, true, "rgb")
    gEB:SetPoint("TOPLEFT", rEB, "TOPRIGHT", 7, 0)
    
    -- blue
    bEB = CreateEB("B", 40, 20, true, "rgb")
    bEB:SetPoint("TOPLEFT", gEB, "TOPRIGHT", 7, 0)

    -- alpha
    aEB = CreateEB("A", 61, 20, true)
    aEB:SetPoint("TOPLEFT", bEB, "TOPRIGHT", 7, 0)

    -- hue
    h_EB = CreateEB("H", 40, 20, true, "hsb")
    h_EB:SetPoint("TOPLEFT", rEB, "BOTTOMLEFT", 0, -25)

    -- saturation
    s_EB = CreateEB("S", 40, 20, true, "hsb")
    s_EB:SetPoint("TOPLEFT", h_EB, "TOPRIGHT", 7, 0)

    -- brightness
    b_EB = CreateEB("B", 40, 20, true, "hsb")
    b_EB:SetPoint("TOPLEFT", s_EB, "TOPRIGHT", 7, 0)

    -- hex
    hexEB = CreateEB("Hex", 61, 20, false, "rgb")
    hexEB:SetPoint("TOPLEFT", b_EB, "TOPRIGHT", 7, 0)

    --------------------------------------------------
    -- buttons
    --------------------------------------------------
    confirmBtn = addon:CreateButton(colorPicker, L["Confirm"], "green", {97, 20})
    confirmBtn:SetPoint("BOTTOMLEFT", 7, 7)
    
    cancelBtn = addon:CreateButton(colorPicker, L["Cancel"], "red", {97, 20})
    cancelBtn:SetPoint("BOTTOMRIGHT", -7, 7)
end

-------------------------------------------------
-- show
-------------------------------------------------
function addon:ShowColorPicker(callback, onConfirm, hasAlpha, r, g, b, a)
    if not colorPicker then
        CreateColorPicker()
    end

    -- clear previous
    brightness.prev = nil
    alpha.prev = nil

    -- already shown, restore previous
    if colorPicker:IsShown() then
        if Callback then
            Callback(oR, oG, oB, oA)
        end
    end

    -- backup for restore
    oR, oG, oB, oA = r or 1, g or 1, b or 1, a or 1

    -- data & callback
    H, S, B = F:ConvertRGBToHSB(oR, oG, oB)
    A = oA
    Callback = callback

    confirmBtn:SetScript("OnClick", function()
        colorPicker:Hide()
        if onConfirm then
            local r, g, b = F:ConvertHSBToRGB(H, S, B)
            onConfirm(r, g, b, A)
        end
    end)

    cancelBtn:SetScript("OnClick", function()
        colorPicker:Hide()
        if callback then callback(oR, oG, oB, oA) end
    end)

    -- update original
    original:SetColor(oR, oG, oB, oA)

    -- update all
    UpdateAll("rgb", oR, oG, oB, oA, true, true)
    addon:SetEnabled(hasAlpha, alpha, aEB, aEB.label)

    P:PixelPerfectPoint(colorPicker)
    colorPicker:Show()
end