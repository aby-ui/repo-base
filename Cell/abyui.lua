local _, Cell = ...
local F = Cell.funcs
local I = Cell.iFuncs
local B = Cell.bFuncs
local P = Cell.pixelPerfectFuncs

function F:IterateAllUnitButtonsAndPreviews(func, updateCurrentGroupOnly)
    F:IterateAllUnitButtons(func, updateCurrentGroupOnly)
    Cell:RegisterCallback("CreatePreview", "RunSnippetsForPreview"..tostring(func), function(...)
        for i = 1, select("#", ...) do
            local b = select(i, ...);
            func(b)
        end
    end)
end

local function rawhook(object, funcKey, postFunc)
    local origin = object[funcKey]
    object[funcKey] = function(...)
        local a,b,c,d,e,f,g,i,j,k = origin(...)
        postFunc(...)
        return a,b,c,d,e,f,g,i,j,k
    end
end

local CooldownIcons_BlizzardStyle = function()
    -- blizzard style cooldown animation
    -- 暴雪样式图标
    local COLOR_BORDER_BY_DISPEL_TYPE = true
    local DRAW_EDGE = true

    -------------------------------------------------
    -- override customs
    -------------------------------------------------
    local F = Cell.funcs
    local I = Cell.iFuncs
    local P = Cell.pixelPerfectFuncs

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
                        remain = string.format("%dm", remain/60)
                    else
                        if Cell.vars.iconDurationRoundUp then
                            remain = math.ceil(remain)
                        else
                            if remain < Cell.vars.iconDurationDecimal then
                                remain = string.format("%.1f", remain)
                            else
                                remain = string.format("%d", remain)
                            end
                        end
                    end

                    frame.duration:SetText(remain)
                end)
            else
                frame.cooldown:SetCooldown(start, duration)
                frame.cooldown:Show()
                frame.duration:Hide()
            end
        end

        local r, g, b
        if COLOR_BORDER_BY_DISPEL_TYPE and debuffType then
            r, g, b = DebuffTypeColor[debuffType].r, DebuffTypeColor[debuffType].g, DebuffTypeColor[debuffType].b
        else
            r, g, b = 0, 0, 0
        end

        frame:SetBackdropColor(r, g, b, 1)
        frame.icon:SetTexture(texture)
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

        local cooldown = CreateFrame("Cooldown", name.."Cooldown", frame, "CooldownFrameTemplate")
        frame.cooldown = cooldown
        cooldown:SetAllPoints(frame)
        cooldown:SetReverse(true)
        cooldown.noCooldownCount = true -- disable omnicc
        cooldown:SetHideCountdownNumbers(true)
        cooldown:SetDrawEdge(DRAW_EDGE)

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
            P:Repoint(stack)
            P:Repoint(duration)
        end

        return frame
    end

    -------------------------------------------------
    -- override built-ins
    -------------------------------------------------
    local function CreateCooldown(f)
        local cooldown = CreateFrame("Cooldown", f:GetName().."Cooldown", f, "CooldownFrameTemplate")
        f.cooldown = cooldown
        cooldown:SetAllPoints(f)
        cooldown:SetReverse(true)
        cooldown.noCooldownCount = true -- disable omnicc
        cooldown:SetHideCountdownNumbers(true)
        cooldown:SetDrawEdge(DRAW_EDGE)
        f.SetCooldown = BarIcon_SetCooldown
    end

    F:IterateAllUnitButtons(function(b)
        -- debuffs
        for i = 1, 10 do
            CreateCooldown(b.indicators.debuffs[i])
            rawhook(b.indicators.debuffs[i], "SetCooldown", function(self, start, duration, debuffType, texture, count, refreshing, isBigDebuff)
                if isBigDebuff then
                    P:Size(self, b.indicators.debuffs.bigSize[1], b.indicators.debuffs.bigSize[2])
                else
                    P:Size(self, b.indicators.debuffs.normalSize[1], b.indicators.debuffs.normalSize[2])
                end
            end)
        end

        for i = 1, 5 do
            -- defensives
            CreateCooldown(b.indicators.defensiveCooldowns[i])
            -- externals
            CreateCooldown(b.indicators.externalCooldowns[i])
            -- all
            CreateCooldown(b.indicators.allCooldowns[i])
        end

    end)
end

--- 让损失血量条和损失能量条作为整个UnitButton的背景
-- Cell默认损失血量条是拼接在血条后面而不是层叠的，这样会导致超出距离设置Alpha时只有透明度变化没有颜色变化，不够明显
-- 预览效果 /run CellSoloFramePlayer:SetAlpha(0.5) CellPartyFrameMember1:SetAlpha(0.5)
local function LossBarSetAllPoints()
    local OriginSetOrientation = B.SetOrientation
    function B:SetOrientation(button, ...)
        OriginSetOrientation(self, button, ...)
        P:Point(button.widget.healthBarLoss, "BOTTOMLEFT", button.widget.healthBar)
        P:Point(button.widget.powerBarLoss, "BOTTOMLEFT", button.widget.powerBar)
    end
end

hooksecurefunc(F, "RunSnippets", function()
    if U1GetCfgValue then
        if U1GetCfgValue("Cell", "cdBlizStyle") then CooldownIcons_BlizzardStyle() end
        if U1GetCfgValue("Cell", "LossBarBG") then LossBarSetAllPoints() end
    end

    I:UpdateCustomDefensives({
        6940, -- PALADIN 牺牲祝福,自身也有
        199754, -- ROGUE, 还击 2min 招架提高100% 狂徒贼替代闪避
        45182, -- ROGUE, 装死 buff 6min 3s
        327140, -- 炉脉幻想
        --320227, -- 灵种
    })
    I:UpdateCustomExternals({
        10060, -- PRIEST 能量灌注
        29166, -- DRUID 激活
        --77764, -- DRUID 狂奔怒吼
    })
    --[[ 以下为减益，需要单独创建减益监视
        87023 炙灼
        25771 自律
        116888 炼狱蔽体
    --]]
end)