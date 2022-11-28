local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local I = Cell.iFuncs
local P = Cell.pixelPerfectFuncs

local DebuffTypeColor = F:Copy(DebuffTypeColor)
DebuffTypeColor.cleu = {r=0, g=1, b=1}
-------------------------------------------------
-- CreateAura_BorderIcon
-------------------------------------------------
local function BorderIcon_SetFont(frame, font, size, flags, xOffset, yOffset)
    if not strfind(strlower(font), ".ttf") then font = F:GetFont(font) end

    if flags == "Shadow" then
        frame.stack:SetFont(font, size, "")
        frame.stack:SetShadowOffset(1, -1)
        frame.stack:SetShadowColor(0, 0, 0, 1)
        frame.duration:SetFont(font, size, "")
        frame.duration:SetShadowOffset(1, -1)
        frame.duration:SetShadowColor(0, 0, 0, 1)
    else
        if flags == "None" then
            flags = ""
        elseif flags == "Outline" then
            flags = "OUTLINE"
        else
            flags = "OUTLINE, MONOCHROME"
        end
        frame.stack:SetFont(font, size, flags)
        frame.stack:SetShadowOffset(0, 0)
        frame.stack:SetShadowColor(0, 0, 0, 0)
        frame.duration:SetFont(font, size, flags)
        frame.duration:SetShadowOffset(0, 0)
        frame.duration:SetShadowColor(0, 0, 0, 0)
    end
    P:ClearPoints(frame.stack)
    P:Point(frame.stack, "TOPRIGHT", frame.textFrame, "TOPRIGHT", xOffset, yOffset)
    P:ClearPoints(frame.duration)
    P:Point(frame.duration, "BOTTOMRIGHT", frame.textFrame, "BOTTOMRIGHT", xOffset, -yOffset)
end

local function BorderIcon_SetCooldown(frame, start, duration, debuffType, texture, count, refreshing)
    local r, g, b
    if debuffType then
        r, g, b = DebuffTypeColor[debuffType].r, DebuffTypeColor[debuffType].g, DebuffTypeColor[debuffType].b
    else
        r, g, b = 0, 0, 0
    end

    if duration == 0 then
        frame.border:Show()
        frame.border:SetColorTexture(r, g, b)
        frame.cooldown:Hide()
        frame.duration:Hide()
        frame:SetScript("OnUpdate", nil)
    else
        frame.border:Hide()
        frame.cooldown:Show()
        frame.cooldown:SetSwipeColor(r, g, b)
        frame.cooldown:SetCooldown(start, duration)
        frame.duration:Show()

        local fmt
        frame:SetScript("OnUpdate", function()
            local remain = duration-(GetTime()-start)
            if remain < 0 then remain = 0 end

            -- color
            if Cell.vars.iconDurationColors then
                if remain < Cell.vars.iconDurationColors[3][4] then
                    frame.duration:SetTextColor(Cell.vars.iconDurationColors[3][1], Cell.vars.iconDurationColors[3][2], Cell.vars.iconDurationColors[3][3])
                elseif remain < (Cell.vars.iconDurationColors[2][4] * duration) then
                    frame.duration:SetTextColor(Cell.vars.iconDurationColors[2][1], Cell.vars.iconDurationColors[2][2], Cell.vars.iconDurationColors[2][3])
                else
                    frame.duration:SetTextColor(Cell.vars.iconDurationColors[1][1], Cell.vars.iconDurationColors[1][2], Cell.vars.iconDurationColors[1][3])
                end
            else
                frame.duration:SetTextColor(1, 1, 1)
            end

            -- format
            if remain > 60 then
                fmt, remain = "%dm", remain/60
            else
                if Cell.vars.iconDurationRoundUp then
                    fmt, remain = "%d", ceil(remain)
                else
                    if remain < Cell.vars.iconDurationDecimal then
                        fmt = "%.1f"
                    else
                        fmt = "%d"
                    end
                end
            end

            frame.duration:SetFormattedText(fmt, remain)
        end)
    end

    frame.icon:SetTexture(texture)
    frame.stack:SetText((count == 0 or count == 1) and "" or count)
    frame:Show()

    if refreshing then
        frame.ag:Play()
    end
end

function I:CreateAura_BorderIcon(name, parent, borderSize)
    local frame = CreateFrame("Frame", name, parent, "BackdropTemplate")
    frame:Hide()
    -- frame:SetSize(11, 11)
    frame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    frame:SetBackdropColor(0, 0, 0, 0.75)
    
    local border = frame:CreateTexture(name.."Border", "BORDER")
    frame.border = border
    border:SetAllPoints(frame)
    border:Hide()

    local cooldown = CreateFrame("Cooldown", name.."Cooldown", frame)
    frame.cooldown = cooldown
    cooldown:SetAllPoints(frame)
    cooldown:SetSwipeTexture("Interface\\Buttons\\WHITE8x8")
    cooldown:SetSwipeColor(1, 1, 1)
    cooldown.noCooldownCount = true -- disable omnicc
    cooldown:SetHideCountdownNumbers(true)

    local iconFrame = CreateFrame("Frame", name.."IconFrame", frame)
    P:Point(iconFrame, "TOPLEFT", frame, "TOPLEFT", borderSize, -borderSize)
    P:Point(iconFrame, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -borderSize, borderSize)
    iconFrame:SetFrameLevel(cooldown:GetFrameLevel()+1)

    local icon = iconFrame:CreateTexture(name.."Icon", "ARTWORK")
    frame.icon = icon
    icon:SetTexCoord(0.12, 0.88, 0.12, 0.88)
    icon:SetAllPoints(iconFrame)

    local textFrame = CreateFrame("Frame", nil, iconFrame)
    textFrame:SetAllPoints(frame)
    frame.textFrame = textFrame

    local stack = textFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_STATUS")
    frame.stack = stack
    stack:SetJustifyH("RIGHT")
    P:Point(stack, "TOPRIGHT", textFrame, "TOPRIGHT", 2, 1)

    local duration = textFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_STATUS")
    frame.duration = duration
    duration:SetJustifyH("RIGHT")
    P:Point(duration, "BOTTOMRIGHT", textFrame, "BOTTOMRIGHT", 2, -1)

    function frame:SetBorder(thickness)
        P:ClearPoints(iconFrame)
        P:Point(iconFrame, "TOPLEFT", frame, "TOPLEFT", thickness, -thickness)
        P:Point(iconFrame, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -thickness, thickness)
    end

    frame.SetFont = BorderIcon_SetFont

    local ag = frame:CreateAnimationGroup()
    frame.ag = ag
    local t1 = ag:CreateAnimation("Translation")
    t1:SetOffset(0, 5)
    t1:SetDuration(0.1)
    t1:SetOrder(1)
    t1:SetSmoothing("OUT")
    local t2 = ag:CreateAnimation("Translation")
    t2:SetOffset(0, -5)
    t2:SetDuration(0.1)
    t2:SetOrder(2)
    t2:SetSmoothing("IN")

    frame.SetCooldown = BorderIcon_SetCooldown

    function frame:UpdatePixelPerfect()
        P:Resize(frame)
        P:Repoint(frame)
        P:Repoint(iconFrame)
        P:Repoint(stack)
        P:Repoint(duration)
    end

    return frame
end

-------------------------------------------------
-- CreateAura_BarIcon
-------------------------------------------------
local function BarIcon_SetFont(frame, font, size, flags, xOffset, yOffset)
    if not strfind(strlower(font), ".ttf") then font = F:GetFont(font) end

    if flags == "Shadow" then
        frame.stack:SetFont(font, size, "")
        frame.stack:SetShadowOffset(1, -1)
        frame.stack:SetShadowColor(0, 0, 0, 1)
        frame.duration:SetFont(font, size, "")
        frame.duration:SetShadowOffset(1, -1)
        frame.duration:SetShadowColor(0, 0, 0, 1)
    else
        if flags == "None" then
            flags = ""
        elseif flags == "Outline" then
            flags = "OUTLINE"
        else
            flags = "OUTLINE, MONOCHROME"
        end
        frame.stack:SetFont(font, size, flags)
        frame.stack:SetShadowOffset(0, 0)
        frame.stack:SetShadowColor(0, 0, 0, 0)
        frame.duration:SetFont(font, size, flags)
        frame.duration:SetShadowOffset(0, 0)
        frame.duration:SetShadowColor(0, 0, 0, 0)
    end
    P:ClearPoints(frame.stack)
    P:Point(frame.stack, "TOPRIGHT", frame.textFrame, "TOPRIGHT", xOffset, yOffset)
    P:ClearPoints(frame.duration)
    P:Point(frame.duration, "BOTTOMRIGHT", frame.textFrame, "BOTTOMRIGHT", xOffset, -yOffset)
end

local function BarIcon_SetCooldown(frame, start, duration, debuffType, texture, count, refreshing)
    if duration == 0 then
        frame.cooldown:Hide()
        frame.duration:Hide()
        frame:SetScript("OnUpdate", nil)
    else
        if frame.showDuration then
            frame.cooldown:Hide()
            frame.duration:Show()

            local fmt
            frame:SetScript("OnUpdate", function()
                local remain = duration-(GetTime()-start)
                if remain < 0 then remain = 0 end

                -- color
                if Cell.vars.iconDurationColors then
                    if remain < Cell.vars.iconDurationColors[3][4] then
                        frame.duration:SetTextColor(Cell.vars.iconDurationColors[3][1], Cell.vars.iconDurationColors[3][2], Cell.vars.iconDurationColors[3][3])
                    elseif remain < (Cell.vars.iconDurationColors[2][4] * duration) then
                        frame.duration:SetTextColor(Cell.vars.iconDurationColors[2][1], Cell.vars.iconDurationColors[2][2], Cell.vars.iconDurationColors[2][3])
                    else
                        frame.duration:SetTextColor(Cell.vars.iconDurationColors[1][1], Cell.vars.iconDurationColors[1][2], Cell.vars.iconDurationColors[1][3])
                    end
                else
                    frame.duration:SetTextColor(1, 1, 1)
                end

                -- format
                if remain > 60 then
                    fmt, remain = "%dm", remain/60
                else
                    if Cell.vars.iconDurationRoundUp then
                        fmt, remain = "%d", ceil(remain)
                    else
                        if remain < Cell.vars.iconDurationDecimal then
                            fmt = "%.1f"
                        else
                            fmt = "%d"
                        end
                    end
                end

                frame.duration:SetFormattedText(fmt, remain)
            end)
        else
            -- init bar values
            frame.cooldown:SetMinMaxValues(0, duration)
            frame.cooldown:SetValue(GetTime()-start)
            frame.cooldown:Show()
            frame.duration:Hide()
        end
    end

    local r, g, b
    if debuffType then
        r, g, b = DebuffTypeColor[debuffType].r, DebuffTypeColor[debuffType].g, DebuffTypeColor[debuffType].b
        frame.spark:SetColorTexture(r, g, b, 1)
    else
        r, g, b = 0, 0, 0
        frame.spark:SetColorTexture(0.5, 0.5, 0.5, 1)
    end

    frame:SetBackdropColor(r, g, b, 1)
    frame.icon:SetTexture(texture)
    frame.maskIcon:SetTexture(texture)
    frame.stack:SetText((count == 0 or count == 1) and "" or count)
    frame:Show()

    if refreshing then
        frame.ag:Play()
    end
end

function I:CreateAura_BarIcon(name, parent)
    local frame = CreateFrame("Frame", name, parent, "BackdropTemplate")
    frame:Hide()
    -- frame:SetSize(11, 11)
    frame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    frame:SetBackdropColor(0, 0, 0, 1)

    local icon = frame:CreateTexture(name.."Icon", "ARTWORK")
    frame.icon = icon
    icon:SetTexCoord(0.12, 0.88, 0.12, 0.88)
    P:Point(icon, "TOPLEFT", frame, "TOPLEFT", 1, -1)
    P:Point(icon, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
    -- icon:SetDrawLayer("ARTWORK", 1)

    local cooldown = CreateFrame("StatusBar", name.."CooldownBar", frame)
    frame.cooldown = cooldown
    cooldown:SetPoint("TOPLEFT", icon)
    cooldown:SetPoint("BOTTOMRIGHT", icon)
    cooldown:SetOrientation("VERTICAL")
    cooldown:SetReverseFill(true)
    -- cooldown:SetFillStyle("REVERSE")
    cooldown:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    cooldown:GetStatusBarTexture():SetAlpha(0)

    local elapsedTime = 0
    cooldown:SetScript("OnUpdate", function(self, elapsed)
        -- cooldown:SetValue(GetTime()-cooldown.start)
        if elapsedTime >= 0.1 then
            cooldown:SetValue(cooldown:GetValue() + elapsedTime)
            elapsedTime = 0
        end
        elapsedTime = elapsedTime + elapsed
    end)

    local spark = cooldown:CreateTexture(nil, "OVERLAY")
    frame.spark = spark
    P:Height(spark, 1)
    spark:SetBlendMode("ADD")
    spark:SetPoint("TOPLEFT", cooldown:GetStatusBarTexture(), "BOTTOMLEFT")
    spark:SetPoint("TOPRIGHT", cooldown:GetStatusBarTexture(), "BOTTOMRIGHT")
    
    local mask = frame:CreateMaskTexture()
    mask:SetTexture("Interface\\Buttons\\WHITE8x8", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetPoint("TOPLEFT")
    mask:SetPoint("BOTTOMRIGHT", cooldown:GetStatusBarTexture())

    local maskIcon = cooldown:CreateTexture(name.."MaskIcon", "ARTWORK")
    frame.maskIcon = maskIcon
    maskIcon:SetTexCoord(0.12, 0.88, 0.12, 0.88)
    maskIcon:SetDesaturated(true)
    maskIcon:SetAllPoints(icon)
    -- maskIcon:SetDrawLayer("ARTWORK", 0)
    maskIcon:SetVertexColor(0.5, 0.5, 0.5, 1)
    maskIcon:AddMaskTexture(mask)

    frame:SetScript("OnSizeChanged", function(self, width, height)
        -- keep aspect ratio
        icon:SetTexCoord(unpack(F:GetTexCoord(width, height)))
        maskIcon:SetTexCoord(unpack(F:GetTexCoord(width, height)))
    end)

    local textFrame = CreateFrame("Frame", nil, frame)
    frame.textFrame = textFrame
    textFrame:SetAllPoints(frame)
    textFrame:SetFrameLevel(cooldown:GetFrameLevel()+1)

    local stack = textFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_STATUS")
    frame.stack = stack
    stack:SetJustifyH("RIGHT")
    P:Point(stack, "TOPRIGHT", textFrame, "TOPRIGHT", 2, 0)

    local duration = textFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_STATUS")
    frame.duration = duration
    duration:SetJustifyH("RIGHT")
    P:Point(duration, "BOTTOMRIGHT", textFrame, "BOTTOMRIGHT", 2, 0)
    duration:Hide()

    frame.SetFont = BarIcon_SetFont

    local ag = frame:CreateAnimationGroup()
    frame.ag = ag
    local t1 = ag:CreateAnimation("Translation")
    t1:SetOffset(0, 5)
    t1:SetDuration(0.1)
    t1:SetOrder(1)
    t1:SetSmoothing("OUT")
    local t2 = ag:CreateAnimation("Translation")
    t2:SetOffset(0, -5)
    t2:SetDuration(0.1)
    t2:SetOrder(2)
    t2:SetSmoothing("IN")

    frame.SetCooldown = BarIcon_SetCooldown

    -- frame:SetScript("OnEnter", function()
        -- local f = frame
        -- repeat
        --     f = f:GetParent()
        -- until f:IsObjectType("button")
        -- f:GetScript("OnEnter")(f)
    -- end)
    
    function frame:ShowDuration(show)
        frame.showDuration = show
        if show then
            duration:Show()
            cooldown:Hide()
        else
            duration:Hide()
            cooldown:Show()
        end
    end

    function frame:UpdatePixelPerfect()
        P:Resize(frame)
        P:Repoint(frame)
        P:Repoint(icon)
        P:Repoint(cooldown)
        P:Resize(spark)
        P:Repoint(stack)
        P:Repoint(duration)
    end

    return frame
end

-------------------------------------------------
-- CreateAura_Text
-------------------------------------------------
local function Text_SetFont(frame, font, size, flags)
    if not strfind(strlower(font), ".ttf") then font = F:GetFont(font) end

    if flags == "Shadow" then
        frame.text:SetFont(font, size, "")
        frame.text:SetShadowOffset(1, -1)
        frame.text:SetShadowColor(0, 0, 0, 1)
    else
        if flags == "None" then
            flags = ""
        elseif flags == "Outline" then
            flags = "OUTLINE"
        else
            flags = "OUTLINE, MONOCHROME"
        end
        frame.text:SetFont(font, size, flags)
        frame.text:SetShadowOffset(0, 0)
        frame.text:SetShadowColor(0, 0, 0, 0)
    end

    local point = frame:GetPoint(1)
    frame.text:ClearAllPoints()
    if string.find(point, "LEFT") then
        frame.text:SetPoint("LEFT")
    elseif string.find(point, "RIGHT") then
        frame.text:SetPoint("RIGHT")
    else
        frame.text:SetPoint("CENTER")
    end
    frame:SetSize(size+3, size+3)
end

local circled = {"①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩","⑪","⑫","⑬","⑭","⑮","⑯","⑰","⑱","⑲","⑳","㉑","㉒","㉓","㉔","㉕","㉖","㉗","㉘","㉙","㉚","㉛","㉜","㉝","㉞","㉟","㊱","㊲","㊳","㊴","㊵","㊶","㊷","㊸","㊹","㊺","㊻","㊼","㊽","㊾","㊿"}
local function Text_SetCooldown(frame, start, duration, debuffType, texture, count)
    if duration == 0 then
        count = count == 0 and 1 or count
        count = frame.circledStackNums and circled[count] or count
        frame.text:SetText(count)
        frame:SetScript("OnUpdate", nil)
    else
        local fmt
        if frame.durationTbl[1] then
            if count == 0 or (count == 1 and not frame.circledStackNums) then --abyui
                fmt, count = "%s", ""
            elseif frame.circledStackNums then
                fmt, count = "%s ", circled[count] .. " "
            else
                fmt = "%d "
            end
            frame:SetScript("OnUpdate", function()
                local remain = duration-(GetTime()-start)
                if remain < 0 then remain = 0 end

                -- color
                if remain <= frame.colors[3][4] then
                    frame.text:SetTextColor(frame.colors[3][1], frame.colors[3][2], frame.colors[3][3])
                elseif remain <= duration * frame.colors[2][4] then
                    frame.text:SetTextColor(frame.colors[2][1], frame.colors[2][2], frame.colors[2][3])
                else
                    frame.text:SetTextColor(frame.colors[1][1], frame.colors[1][2], frame.colors[1][3])
                end

                -- format
                local fmt2
                if remain > 60 then
                    fmt2, remain = fmt .. "%dm", remain/60
                else
                    if frame.durationTbl[2] then
                        fmt2, remain = fmt .. "%d", remain + 0.9999
                        remain = remain < 1 and 1 or remain
                    else
                        if remain < frame.durationTbl[3] then
                            fmt2 = fmt .. "%.1f"
                        else
                            fmt2 = fmt .. "%d"
                        end
                    end
                end
                frame.text:SetFormattedText(fmt2, count, remain)
            end)
        else
            count = count == 0 and 1 or count
            if frame.circledStackNums then
                fmt = circled[count]
                count = nil
            else
                fmt = "%d"
            end
            frame:SetScript("OnUpdate", function()
                local remain = duration-(GetTime()-start)
                -- update color
                if remain <= frame.colors[3][4] then
                    frame.text:SetTextColor(frame.colors[3][1], frame.colors[3][2], frame.colors[3][3])
                elseif remain <= duration * frame.colors[2][4] then
                    frame.text:SetTextColor(frame.colors[2][1], frame.colors[2][2], frame.colors[2][3])
                else
                    frame.text:SetTextColor(frame.colors[1][1], frame.colors[1][2], frame.colors[1][3])
                end
                -- update text
                frame.text:SetFormattedText(fmt, count)
            end)

        end
    end

    frame:Show()
end

function I:CreateAura_Text(name, parent)
    local frame = CreateFrame("Frame", name, parent)
    frame:SetSize(11, 11)
    frame:Hide()
    frame.indicatorType = "text"

    local text = frame:CreateFontString(nil, "OVERLAY", "CELL_FONT_STATUS")
    frame.text = text
    -- stack:SetJustifyH("RIGHT")
    text:SetPoint("CENTER", 1, 0)

    frame.SetFont = Text_SetFont

    frame.OriginalSetPoint = frame.SetPoint
    function frame:SetPoint(point, relativeTo, relativePoint, x, y)
        text:ClearAllPoints()
        if string.find(point, "LEFT") then
            text:SetPoint("LEFT")
        elseif string.find(point, "RIGHT") then
            text:SetPoint("RIGHT")
        else
            text:SetPoint("CENTER")
        end
        frame:OriginalSetPoint(point, relativeTo, relativePoint, x, y)
    end

    frame.SetCooldown = Text_SetCooldown

    function frame:SetDuration(durationTbl)
        frame.durationTbl = durationTbl
    end

    function frame:SetCircledStackNums(circled)
        frame.circledStackNums = circled
    end

    function frame:SetColors(colors)
        frame.colors = colors
    end
        
    return frame
end

-------------------------------------------------
-- CreateAura_Rect
-------------------------------------------------
local function Rect_SetFont(frame, font, size, flags, xOffset, yOffset)
    if not strfind(strlower(font), ".ttf") then font = F:GetFont(font) end

    if flags == "Shadow" then
        frame.stack:SetFont(font, size, "")
        frame.stack:SetShadowOffset(1, -1)
        frame.stack:SetShadowColor(0, 0, 0, 1)
    else
        if flags == "None" then
            flags = ""
        elseif flags == "Outline" then
            flags = "OUTLINE"
        else
            flags = "OUTLINE, MONOCHROME"
        end
        frame.stack:SetFont(font, size, flags)
        frame.stack:SetShadowOffset(0, 0)
        frame.stack:SetShadowColor(0, 0, 0, 0)
    end
    P:ClearPoints(frame.stack)
    P:Point(frame.stack, "CENTER", frame, "CENTER", xOffset, yOffset)
end

local function Rect_SetCooldown(frame, start, duration, debuffType, texture, count)
    if duration == 0 then
        frame.tex:SetColorTexture(unpack(frame.colors[1]))
        frame:SetScript("OnUpdate", nil)
    else
        frame:SetScript("OnUpdate", function()
            local remain = duration-(GetTime()-start)
            -- update color
            if remain <= frame.colors[3][4] then
                frame.tex:SetColorTexture(frame.colors[3][1], frame.colors[3][2], frame.colors[3][3])
            elseif remain <= duration * frame.colors[2][4] then
                frame.tex:SetColorTexture(frame.colors[2][1], frame.colors[2][2], frame.colors[2][3])
            else
                frame.tex:SetColorTexture(unpack(frame.colors[1]))
            end
        end)
    end

    frame.stack:SetText((count == 0 or count == 1) and "" or count)
    frame:Show()
end

function I:CreateAura_Rect(name, parent)
    local frame = CreateFrame("Frame", name, parent, "BackdropTemplate")
    -- frame:SetSize(11, 4)
    frame:Hide()
    frame.indicatorType = "rect"
    frame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    frame:SetBackdropColor(0, 0, 0, 1)

    local tex = frame:CreateTexture(nil, "ARTWORK")
    frame.tex = tex
    P:Point(tex, "TOPLEFT", frame, "TOPLEFT", 1, -1)
    P:Point(tex, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)

    frame.stack = frame:CreateFontString(nil, "OVERLAY")

    frame.SetFont = Rect_SetFont
    frame.SetCooldown = Rect_SetCooldown

    function frame:SetColors(colors)
        frame.colors = colors
    end

    function frame:ShowStack(show)
        if show then
            frame.stack:Show()
        else
            frame.stack:Hide()
        end
    end

    function frame:UpdatePixelPerfect()
        P:Resize(frame)
        P:Repoint(frame)
        P:Repoint(tex)
    end
        
    return frame
end

-------------------------------------------------
-- CreateAura_Bar
-------------------------------------------------
local function Bar_SetFont(bar, font, size, flags, xOffset, yOffset)
    if not strfind(strlower(font), ".ttf") then font = F:GetFont(font) end

    if flags == "Shadow" then
        bar.stack:SetFont(font, size, "")
        bar.stack:SetShadowOffset(1, -1)
        bar.stack:SetShadowColor(0, 0, 0, 1)
    else
        if flags == "None" then
            flags = ""
        elseif flags == "Outline" then
            flags = "OUTLINE"
        else
            flags = "OUTLINE, MONOCHROME"
        end
        bar.stack:SetFont(font, size, flags)
        bar.stack:SetShadowOffset(0, 0)
        bar.stack:SetShadowColor(0, 0, 0, 0)
    end
    P:ClearPoints(bar.stack)
    P:Point(bar.stack, "CENTER", bar, "CENTER", xOffset, yOffset)
end

local function Bar_SetCooldown(bar, start, duration, debuffType, texture, count)
    if duration == 0 then
        bar:SetScript("OnUpdate", nil)
        bar:SetMinMaxValues(0, 1)
        bar:SetValue(1)
        bar:SetStatusBarColor(unpack(bar.colors[1]))
    else
        bar:SetMinMaxValues(0, duration)
        bar:SetValue(GetTime()-start)
        bar:SetScript("OnUpdate", function()
            local remain = duration-(GetTime()-start)
            bar:SetValue(remain)
            -- update color
            if remain <= bar.colors[3][4] then
                bar:SetStatusBarColor(bar.colors[3][1], bar.colors[3][2], bar.colors[3][3])
            elseif remain <= duration * bar.colors[2][4] then
                bar:SetStatusBarColor(bar.colors[2][1], bar.colors[2][2], bar.colors[2][3])
            else
                bar:SetStatusBarColor(unpack(bar.colors[1]))
            end
        end)
    end

    bar.stack:SetText((count == 0 or count == 1) and "" or count)
    bar:Show()
end

function I:CreateAura_Bar(name, parent)
    local bar = Cell:CreateStatusBar(name, parent, 18, 4, 100)
    bar:Hide()
    bar.indicatorType = "bar"

    bar.stack = bar.border:CreateFontString(nil, "OVERLAY")

    bar.SetFont = Bar_SetFont
    bar.SetCooldown = Bar_SetCooldown

    function bar:SetColors(colors)
        bar.colors = colors
    end

    function bar:ShowStack(show)
        if show then
            bar.stack:Show()
        else
            bar.stack:Hide()
        end
    end
        
    return bar
end

-------------------------------------------------
-- CreateAura_Color
-------------------------------------------------
function I:CreateAura_Color(name, parent)
    local color = CreateFrame("Frame", name, parent)
    color:SetFrameLevel(8)
    color:Hide()
    color.indicatorType = "color"

    local solidTex = color:CreateTexture(nil, "ARTWORK")
    solidTex:SetTexture(Cell.vars.texture)
    solidTex:SetAllPoints(color)
    solidTex:Hide()
   
    local gradientTex = color:CreateTexture(nil, "ARTWORK")
    gradientTex:SetTexture("Interface\\Buttons\\WHITE8x8")
    gradientTex:SetAllPoints(color)
    gradientTex:Hide()

    function color:SetCooldown(start, duration, debuffType, texture, count, refreshing)
        if color.type == "debuff-type" and debuffType then
            solidTex:SetVertexColor(DebuffTypeColor[debuffType]["r"], DebuffTypeColor[debuffType]["g"], DebuffTypeColor[debuffType]["b"], color.alpha)
        end
        color:Show()
    end

    function color:SetAnchor(anchorTo)
        color:ClearAllPoints()
        if anchorTo == "healthbar-current" then
            -- current hp texture
            color:SetAllPoints(parent.widget.healthBar:GetStatusBarTexture())
        elseif anchorTo == "healthbar-entire" then
            -- entire hp bar
            color:SetAllPoints(parent.widget.healthBar)
        else -- unitbutton
            P:Point(color, "TOPLEFT", parent.widget.overlayFrame, "TOPLEFT", 1, -1)
            P:Point(color, "BOTTOMRIGHT", parent.widget.overlayFrame, "BOTTOMRIGHT", -1, 1)
        end
    end

    if Cell.isRetail then
        function color:SetColors(colors)
            color.type = colors[1]
    
            if colors[1] == "solid" then
                solidTex:SetVertexColor(colors[2][1], colors[2][2], colors[2][3], colors[2][4])
                solidTex:SetTexture(Cell.vars.texture)
                solidTex:Show()
                gradientTex:Hide()
            elseif colors[1] == "gradient-vertical" then
                gradientTex:SetGradient("VERTICAL", CreateColor(colors[2][1], colors[2][2], colors[2][3], colors[2][4]), CreateColor(colors[3][1], colors[3][2], colors[3][3], colors[3][4]))
                gradientTex:Show()
                solidTex:Hide()
            elseif colors[1] == "gradient-horizontal" then
                gradientTex:SetGradient("HORIZONTAL", CreateColor(colors[2][1], colors[2][2], colors[2][3], colors[2][4]), CreateColor(colors[3][1], colors[3][2], colors[3][3], colors[3][4]))
                gradientTex:Show()
                solidTex:Hide()
            elseif colors[1] == "debuff-type" then
                solidTex:SetVertexColor(colors[2][1], colors[2][2], colors[2][3], colors[2][4])
                solidTex:SetTexture(Cell.vars.texture)
                solidTex:Show()
                gradientTex:Hide()
                color.alpha = colors[2][4]
            end
        end
    else
        function color:SetColors(colors)
            color.type = colors[1]
    
            if colors[1] == "solid" then
                solidTex:SetVertexColor(colors[2][1], colors[2][2], colors[2][3], colors[2][4])
                solidTex:SetTexture(Cell.vars.texture)
                solidTex:Show()
                gradientTex:Hide()
            elseif colors[1] == "gradient-vertical" then
                gradientTex:SetGradientAlpha("VERTICAL", colors[2][1], colors[2][2], colors[2][3], colors[2][4], colors[3][1], colors[3][2], colors[3][3], colors[3][4])
                gradientTex:Show()
                solidTex:Hide()
            elseif colors[1] == "gradient-horizontal" then
                gradientTex:SetGradientAlpha("HORIZONTAL", colors[2][1], colors[2][2], colors[2][3], colors[2][4], colors[3][1], colors[3][2], colors[3][3], colors[3][4])
                gradientTex:Show()
                solidTex:Hide()
            elseif colors[1] == "debuff-type" then
                solidTex:SetVertexColor(colors[2][1], colors[2][2], colors[2][3], colors[2][4])
                solidTex:SetTexture(Cell.vars.texture)
                solidTex:Show()
                gradientTex:Hide()
                color.alpha = colors[2][4]
            end
        end
    end
        
    return color
end

-------------------------------------------------
-- CreateAura_Texture
-------------------------------------------------
function I:CreateAura_Texture(name, parent)
    local texture = CreateFrame("Frame", name, parent)
    texture:Hide()
    
    local tex = texture:CreateTexture(name, "OVERLAY")
    tex:SetAllPoints(texture)

    function texture:SetCooldown()
        texture:Show()
    end
    
    function texture:SetTexture(texTbl) -- texture, rotation, color
        if strfind(strlower(texTbl[1]), "^interface") then
            tex:SetTexture(texTbl[1])
        else
            tex:SetAtlas(texTbl[1])
        end
        tex:SetRotation(texTbl[2] * math.pi / 180)
        tex:SetVertexColor(unpack(texTbl[3]))
    end

    return texture
end

-------------------------------------------------
-- CreateAura_Icons
-------------------------------------------------
function I:CreateAura_Icons(name, parent, num)
    local icons = CreateFrame("Frame", name, parent)
    icons:Hide()
    icons.indicatorType = "icons"

    icons.OriginalSetSize = icons.SetSize

    function icons:UpdateSize(iconsShown)
        if not (icons.width and icons.height and icons.orientation) then return end -- not init
        if iconsShown then -- call from I:CheckCustomIndicators or preview
            if icons.orientation == "horizontal" then
                icons:OriginalSetSize(icons.width*iconsShown, icons.height)
            else
                icons:OriginalSetSize(icons.width, icons.height*iconsShown)
            end
        else
            for i = 1, num do
                if icons[i]:IsShown() then
                    if icons.orientation == "horizontal" then
                        icons:OriginalSetSize(icons.width*i, icons.height)
                    else
                        icons:OriginalSetSize(icons.width, icons.height*i)
                    end
                end
            end
        end
    end

    function icons:SetSize(width, height)
        icons.width = width
        icons.height = height

        for i = 1, num do
            icons[i]:SetSize(width, height)
        end

        icons:UpdateSize()
    end

    function icons:SetFont(font, ...)
        font = F:GetFont(font)
        for i = 1, num do
            icons[i]:SetFont(font, ...)
        end
    end

    function icons:SetOrientation(orientation)
        local point1, point2
        if orientation == "left-to-right" then
            point1 = "TOPLEFT"
            point2 = "TOPRIGHT"
            icons.orientation = "horizontal"
        elseif orientation == "right-to-left" then
            point1 = "TOPRIGHT"
            point2 = "TOPLEFT"
            icons.orientation = "horizontal"
        elseif orientation == "top-to-bottom" then
            point1 = "TOPLEFT"
            point2 = "BOTTOMLEFT"
            icons.orientation = "vertical"
        elseif orientation == "bottom-to-top" then
            point1 = "BOTTOMLEFT"
            point2 = "TOPLEFT"
            icons.orientation = "vertical"
        end
        
        for i = 1, num do
            P:ClearPoints(icons[i])
            if i == 1 then
                P:Point(icons[i], point1)
            else
                P:Point(icons[i], point1, icons[i-1], point2)
            end
        end

        icons:UpdateSize()
    end

    for i = 1, num do
        local name = name.."Icons"..i
        local frame = I:CreateAura_BarIcon(name, icons)
        icons[i] = frame
    end

    function icons:ShowDuration(show)
        for i = 1, num do
            icons[i]:ShowDuration(show)
        end
    end

    function icons:UpdatePixelPerfect()
        -- P:Resize(icons)
        P:Repoint(icons)
        for i = 1, num do
            icons[i]:UpdatePixelPerfect()
        end
    end

    return icons
end
