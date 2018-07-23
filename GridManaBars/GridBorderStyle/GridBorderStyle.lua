local _, GBS = ...

local media = LibStub("LibSharedMedia-3.0", true)

local L = GBS.L

local GridFrame = Grid:GetModule("GridFrame")
local GridStatus = Grid:GetModule("GridStatus")

local GridBorderStyle = Grid:NewModule("GridBorderStyle", "AceHook-3.0")

GridBorderStyle.defaultDB = {
    style = "OverlapStyle",
    shadow = false,
    debug = false,
    classColor = false,
    overlapPercent = 0.65,
    texSet = true,
    tex = {
        ["Elv"] = "ElvBar",
        ["OverlapStyle"] = "TukNorm",
    },
}
if GridMBFrame.defaultDB then GridMBFrame.defaultDB.size = 0.1 end

local Styles, Textures
local style

---------------------
-- some local libs --
---------------------
local function getTexture(texType, texName)
    if not media:IsValid(texType, texName) then
        local tex = Textures[texName]
        if not tex then error(("%s: file not found."):format(texName)) end
        media:Register(texType, texName, tex)
    end
    return media:Fetch(texType, texName)
end

local function dropShadow(old, frame, outset, parent)
    if not parent then parent = frame end
    local shadow = old or CreateFrame("Frame", nil, parent)
    outset = outset or 0
    shadow:SetFrameStrata("BACKGROUND")
    shadow:SetFrameLevel(1)
    shadow:SetPoint("TOPLEFT", frame, "TOPLEFT", -3 - outset, 3 + outset)
    shadow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 3 + outset, -3 - outset)
    shadow:SetBackdrop({
        edgeFile = getTexture("background", "TukGlow"),
        edgeSize = 3,
        insets = { left = 5, right = 5, top = 5, bottom = 5 },
    })
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(0, 0, 0, .8)
    if GridBorderStyle.db.profile.shadow then
        shadow:Show()
    else
        shadow:Hide()
    end
    return shadow
end

local function addBorderFrame(old, relative, outset, parent)
    if not parent then parent = relative end
    local backdrop = Styles[style].Backdrop
    if old then old:Show() return old end
    local f = old or CreateFrame("Frame", nil, parent)
    f:SetFrameStrata("LOW")
    f:SetFrameLevel(2)
    f:SetBackdrop(backdrop)
    f:SetBackdropColor(unpack(Styles[style].BackdropColor))
    f:SetBackdropBorderColor(unpack(Styles[style].BorderColor))
    f:SetPoint("TOPLEFT", relative, "TOPLEFT", -outset, outset)
    f:SetPoint("BOTTOMRIGHT", relative, "BOTTOMRIGHT", outset, -outset)
    return f
end

------------------------
-- Styles DB      --
------------------------

Textures = {
    ["TukGlow"] = [[Interface\Addons\GridManaBars\GridBorderStyle\medias\glowTex]],
    ["TukBlank"] = [[Interface\Addons\GridManaBars\GridBorderStyle\medias\blank]],
    ["ElvBar"] = [[Interface\Addons\GridManaBars\GridBorderStyle\medias\normTex]],
    ["TukNorm"] = [[Interface\Addons\GridManaBars\GridBorderStyle\medias\tukNorm]],
    ["QulightTex"] = [[Interface\Addons\GridManaBars\GridBorderStyle\medias\QulightTex]],
}


Styles = {
    ["None"] = {
        min = 10,
        ShadowOutset = -2,
    },
    ["Elv"] = {
        type = "Divide",
        min = 2,
        StatusbarTex = "ElvBar",
        Backdrop = {
            bgFile = getTexture("background", "TukBlank"),
            tile = false,
            tileSize = 0,
            edgeFile = getTexture("background", "TukBlank"),
            insets = { left = -1, right = -1, top = -1, bottom = -1 }
        },
        BackdropColor = { .1, .1, .1 },
        BorderColor = { .3, .3, .3 },
        GapbarTex = "TukBlank",
    },
    ["Qulight"] = {
        type = "Isolate",
        min = 4,
        MBAnchorP = "CENTER",
        offset = 6,
        ShadowOutset = -3,
        StatusbarTex = "QulightTex",
        Backdrop = {
            bgFile = getTexture("background", "TukBlank"),
            tile = false,
            tileSize = 0,
            edgeFile = getTexture("background", "TukBlank"),
            edgeSize = 1,
            insets = { left = -1, right = -1, top = -1, bottom = -1 }
        },
        BackdropColor = { .02, .02, .02 },
        BorderColor = { .3, .3, .3 },
    },
    ["OverlapStyle"] = {
        type = "Overlap",
        min = 4,
        MBLengthPer = .60,
        ShadowOutset = -3,
        StatusbarTex = "ElvBar",
        Backdrop = {
            bgFile = getTexture("background", "TukBlank"),
            tile = false,
            tileSize = 0,
            edgeFile = getTexture("background", "TukBlank"),
            edgeSize = 1,
            insets = { left = -1, right = -1, top = -1, bottom = -1 }
        },
        BackdropColor = { .02, .02, .02 },
        BorderColor = { .3, .3, .3 },
    },
    ["LayersStyle"] = {
        type = "Layers",
        min = 5,
        offset = 7,
        ShadowOutset = -3,
        StatusbarTex = "ElvBar",
        Backdrop = {
            bgFile = getTexture("background", "TukBlank"),
            tile = false,
            tileSize = 0,
            edgeFile = getTexture("background", "TukBlank"),
            edgeSize = 1,
            insets = { left = -1, right = -1, top = -1, bottom = -1 }
        },
        BackdropColor = { .02, .02, .02 },
        BorderColor = { .3, .3, .3 },
    }
}

--------------------------------
-- register into Grid options --
--------------------------------

local styleOptions = {
    type = "group",
    name = L["Style"],
    desc = "Style Option",
    args = {
        ["Chosen Style"] = {
            type = "select",
            order = 1,
            name = L["Choose a Style"],
            desc = "Choose a style",
            width = "single",
            get = function()
                return GridBorderStyle.db.profile.style
            end,
            set = function(_, v)
                GridBorderStyle.db.profile.style = v
                style = v
                GridBorderStyle:OnStyleChange()
            end,
            values = {
                ["Elv"] = L["ElvUI"],
                ["Qulight"] = L["Qulight"],
                ["OverlapStyle"] = L["OverlapStyle"],
                ["None"] = NONE,
                ["LayersStyle"] = L["LayersStyle"]
            },
        },
        overlapPercent = {
            type = "range",
            order = 1.1,
            disabled = function() return style ~= "OverlapStyle" end,
            min = 0.3, max = 1, step = 0.05,
            name = L["Overlap Manabar Width %"],
            get = function() return GridBorderStyle.db.profile.overlapPercent end,
            set = function(info, v)
                GridBorderStyle.db.profile.overlapPercent = v
                Styles.OverlapStyle.MBLengthPer = v
                GridBorderStyle:OnStyleChange()
            end,
        },
        ["Shadow"] = {
            type = "toggle",
            order = 2,
            width = "full",
            name = L["Frame Shadow"],
            desc = L["Turn on/off border shade"],
            get = function() return GridBorderStyle.db.profile.shadow end,
            set = function(_, v)
                GridBorderStyle.db.profile.shadow = v
                if v then
                    for _, f in pairs(GridFrame.registeredFrames) do
                        f.Shadow:Show()
                        if f.MBShadow then f.MBShadow:Show() end
                    end
                else
                    for _, f in pairs(GridFrame.registeredFrames) do
                        f.Shadow:Hide()
                        if f.MBShadow then f.MBShadow:Hide() end
                    end
                end
            end,
        },
        ["ClassColor"] = {
            type = "toggle",
            order = 3,
            width = "single",
            name = L["Use class color"],
            desc = L["Color manabar by class"],
            get = function() return GridBorderStyle.db.profile.classColor end,
            set = function()
                GridBorderStyle.db.profile.classColor = not GridBorderStyle.db.profile.classColor
                GridMBStatus:UpdateAllUnits()
            end,
        },
        ["Reloadui"] = {
            type = "execute",
            order = 4,
            name = L["Reload"],
            width = "single",
            desc = L["Reload UI to Apply Style"],
            func = function() ReloadUI() end,
        },
        divide = {
            type = "header",
            order = 5,
            name = L["ManaBar Settings"],
        },
    }
}

local origin_set = GridFrame.options.set
if origin_set then
    GridFrame.options.set = function(info, v)
        local k = info[#info]
        if k == "texture" then
            GridBorderStyle.db.profile.tex[style] = v
        end
        return origin_set(info, v)
    end
else
    DEFAULT_CHAT_FRAME:AddMessage("[WARN] Wrong Grid version, GridBorderStyle may not work properly.", 1, 0, 0);
end

styleOptions.args.texture = Mixin({}, GridFrame.options.args.bar.args.texture, { order = 1.5, width = "single", get = GridFrame.options.get, set = GridFrame.options.set})
styleOptions.args.invertBarColor = Mixin({}, GridFrame.options.args.bar.args.invertBarColor, { order = 1.6, width = "single", get = GridFrame.options.get, set = GridFrame.options.set})

local GridMBOptions = GridMBFrame.options or Grid.options.args["manabar"]
styleOptions.args.side = GridMBOptions.args["Manabar side"]
styleOptions.args.size = GridMBOptions.args["Manabar size"]
styleOptions.args.invert = GridMBOptions.args["Manabar reverse"]

Grid.options.args["GridBorderStyle"] = styleOptions

--------------------------------
-- init and shares      --
--------------------------------

function GridBorderStyle:PostInitialize()
    style = self.db.profile.style
    Styles["OverlapStyle"].MBLengthPer = self.db.profile.overlapPercent
    if not style or not Styles[style] then return end

    --remember the origin options for later use.
    self.manabarSideOptions = self.manabarSideOptions or GridMBOptions.args["Manabar side"].values

    for k, v in pairs(Textures) do
        if not media:IsValid("statusbar", k) then
            media:Register("statusbar", k, v)
        end
    end

    self:RawHook(GridFrame.prototype, "ResetIndicator") --only called in RegisterIndicator
    self:RawHook(GridFrame.prototype, "ResetAllIndicators")
    self:RawHook(GridFrame.prototype, "SetIndicator", "HOOK_SetIndicator")
    self:RawHook(GridFrame.prototype, "ClearIndicator","HOOK_ClearIndicator")

    local fakeGridMBStatus = {
        db = GridMBStatus.db,
        core = setmetatable({
            SendStatusGained = function(self, guid, status, priority, range, color, ...)
                if GridBorderStyle.db.profile.classColor == true then
                    color = GridStatus:UnitColor(guid)
                end
                GridMBStatus.core:SendStatusGained(guid, status, priority, range, color, ...)
            end
        }, { __index = GridMBStatus.core })
    }
    setfenv(GridMBStatus.UpdateUnitPower, setmetatable({ GridMBStatus = fakeGridMBStatus }, { __index = _G }))

    GridBorderStyle:OnStyleChange()

    GridBorderStyle:Debug("Loaded")
end

function GridBorderStyle:OnStyleChange()
    GridMBOptions.args["Manabar size"].min = Styles[style].min
    GridMBFrame.db.profile.size = max(GridMBFrame.db.profile.size, Styles[style].min / 100)

    if Styles[style].type == "Layers" then
        GridMBFrame.options.args["Manabar side"].values = { ["Left"] = L["Topleft"], ["Top"] = L["Topright"], ["Right"] = L["Bottomright"], ["Bottom"] = L["Bottomleft"] }
    else
        GridMBFrame.options.args["Manabar side"].values = GridBorderStyle.manabarSideOptions
    end

    if Styles[style].StatusbarTex then
        local texture = GridBorderStyle.db.profile.tex[style] or Styles[style].StatusbarTex
        GridFrame.db.profile.texture = texture
        GridBorderStyle.db.profile.tex[style] = texture
    end

    GridFrame:UpdateAllFrames()
end

--indicator points those on GridFrame, need to be change to bar.
local function replaceAnchorRelative(indicator, oldRel, newRel)
    for i = 1, indicator:GetNumPoints() do
        local point, relTo, relPoint, x, y = indicator:GetPoint(i)
        if relTo == oldRel then
            indicator:SetPoint(point, newRel, relPoint, x, y)
        end
    end
end

--In new version GridManaBar(for Grid 6+), indicators are force as children of manabar
local manabar_modified = { "icon", "text", "text2", "corner1", "corner2", "corner3", "corner4" }
local function setIndicatorsParent(frame, bar)
    if frame.indicators.manabar:GetFrameLevel() <= bar:GetFrameLevel() then
        for _, v in ipairs(manabar_modified) do
            frame.indicators[v]:SetParent(bar)
        end
    end
end

function GridBorderStyle:ResetIndicator(frame, id)
    self.hooks[GridFrame.prototype].ResetIndicator(frame, id)
    self:HOOK_ResetIndicator(frame, id, frame.indicators[id])
end

function GridBorderStyle:ResetAllIndicators(frame)
    self.hooks[GridFrame.prototype].ResetAllIndicators(frame)
    GridBorderStyle:Debug("ResetAllIndicators")
    for id, indicator in pairs(frame.indicators) do
        self:HOOK_ResetIndicator(frame, id, indicator)
    end

    local bar = frame.indicators.bar

    --former RelocateIndicators hooks hook GridFrame:PlaceIndicator
    --将来new里的设置需要还原，比如icon的icon:SetPoint("CENTER")
    replaceAnchorRelative(frame.indicators.icon, frame, bar)
    replaceAnchorRelative(frame.indicators.text, frame, bar)
    replaceAnchorRelative(frame.indicators.text2, frame, bar)

    if Styles[style].type == "Divide" or style == "None" then
        frame.Shadow = dropShadow(frame.Shadow, frame, Styles[style].ShadowOutset)
    else
        if Styles[style].Backdrop then
            frame.Shadow = dropShadow(frame.Shadow, bar, Styles[style].ShadowOutset + GridFrame.db.profile.borderSize + 4, frame)
        else
            frame.Shadow = dropShadow(frame.Shadow, bar, Styles[style].ShadowOutset + GridFrame.db.profile.borderSize + 1, frame)
        end
    end
end

function GridBorderStyle:HOOK_ResetIndicator(frame, id, indicator)

    local bar = frame.indicators.bar
    local manabar = frame.indicators.manabar

    --former FrameHook hooks SetBorderSize
    if id == "border" then
        if Styles[style].type == "Divide" then
            self.tmpBackdrop = self.tmpBackdrop or {}
            wipe(self.tmpBackdrop)
            Mixin(self.tmpBackdrop, frame:GetBackdrop())
            Mixin(self.tmpBackdrop, Styles[style].Backdrop)
            local r, g, b, a = frame:GetBackdropBorderColor()
            frame:SetBackdrop(self.tmpBackdrop)
            frame:SetBackdropColor(unpack(Styles[style].BackdropColor))
            frame:SetBackdropBorderColor(r, g, b, a)
        elseif Styles[style].Backdrop then
            frame:SetBackdropColor(0, 0, 0, 0)
            frame:SetBackdropBorderColor(0, 0, 0, 0)
        end

    elseif id == "manabar" and GridMBFrame then
        GridBorderStyle:HideStyleBorders(frame)

        if style == "None" or not frame.indicators.manabar or not frame.indicators.manabar:IsShown() then
            self.hooks[GridFrame.prototype].ResetIndicator(frame, "bar")
        else
            -- in "Divide" type style, just pick the original backdrop to spawn border.
            -- in "Isolate" type style, create a border frame under GridFrame & GridMBFrame each.
            -- "Overlap" type is much like "Isolate" ,except that Power Bar frame level is higher.
            GridBorderStyle:ResetManabarPosition(frame, GridMBFrame.db.profile.side)
            setIndicatorsParent(frame, bar)
        end
    end
end

local COLOR_WHITE = { r = 1, g = 1, b = 1, a = 1 }
function GridBorderStyle:HOOK_SetIndicator(frame, id, col, ...)
    self.hooks[GridFrame.prototype].SetIndicator(frame, id, col, ...)

    local manabar = frame.indicators.manabar
    col = col or COLOR_WHITE
    if id == "manabar" and manabar:IsShown() then
        if frame._manabarShown ~= true then
            GridBorderStyle:Debug("Manabar Shown")
            --强制manabar刷新一次，因为manabar的SetStatus只是隐藏/显示，不Reset不行。顺带会调用HOOK_ResetIndicator
            GridBorderStyle:ResetIndicator(frame, "manabar")
            frame._manabarShown = true
        end
        local actualBG = ( Styles[style].type == "Layers" or Styles[style].type == "Overlap" or Styles[style].type == "Isolate" ) and frame.NewMBG or manabar.bg
        if (GridFrame.db.profile.invertBarColor and not GridMBFrame.db.profile.invert) or (not GridFrame.db.profile.invertBarColor and GridMBFrame.db.profile.invert) then
            actualBG:SetVertexColor(0, 0, 0, 0.8)
        else
            actualBG:SetVertexColor(col.r, col.g, col.b, col.a)
        end
        --必须每次都设置，因为manabar:SetStatus里会修改，这里不设置的话，manabar在下层的时候文字看不到
        setIndicatorsParent(frame, frame.indicators.bar)

    elseif id == "border" then
        if Styles[style].type == "Layers" or Styles[style].type == "Overlap" or Styles[style].type == "Isolate" then
            frame:SetBackdropBorderColor(0, 0, 0, 0)
            if frame.HBarBorder then
                frame.HBarBorder:SetBackdropBorderColor(col.r, col.g, col.b, col.a or 1)
            elseif frame.MBBorder then
                frame.MBBorder:SetBackdropBorderColor(col.r, col.g, col.b, col.a or 1)
            end
        end
    end
end

function GridBorderStyle:HOOK_ClearIndicator(frame, indicator, ...)
    self.hooks[GridFrame.prototype].ClearIndicator(frame, indicator, ...)
    if indicator == "border" and Styles[style].BorderColor then
        if Styles[style].type == "Divide" then
            frame:SetBackdropBorderColor(unpack(Styles[style].BorderColor))
        else
            if frame.HBarBorder then
                frame.HBarBorder:SetBackdropBorderColor(unpack(Styles[style].BorderColor))
            end
            if frame.MBBorder then
                frame.MBBorder:SetBackdropBorderColor(unpack(Styles[style].BorderColor))
            end
        end

    elseif indicator == "manabar" then
        if frame._manabarShown ~= false then
            GridBorderStyle:Debug("Manabar hidden", frame:GetName())
            GridBorderStyle:HideStyleBorders(frame)
            self.hooks[GridFrame.prototype].ResetIndicator(frame, "bar") --bar就会重新铺满frame，相当于回滚ResetManabarPosition的操作
            frame._manabarShown = false
        end
    end
end

function GridBorderStyle:HideStyleBorders(frame)
    if frame.Gap then frame.Gap:Hide() end
    if frame.MBBorder then frame.MBBorder:Hide() end
    if frame.MBShadow then frame.MBShadow:Hide() end
    if Styles[style].type == "Isolate" or Styles[style].type == "Overlap" or Styles[style].type == "Layers" then
        frame.HBarBorder = addBorderFrame(frame.HBarBorder, frame.indicators.bar, 2, frame)
    elseif frame.HBarBorder then
        frame.HBarBorder:Hide()
    end
end

function GridBorderStyle:ResetManabarPosition(frame, side)
    local manabar = frame.indicators.manabar
    if not manabar then return end
    local bar = frame.indicators.bar

    local manabarW, manabarH = manabar:GetSize()
    local frameW, frameH = frame:GetSize()

    if Styles[style].type == "Divide" then
        if not frame.Gap then
            frame.Gap = bar:CreateTexture(nil, "ARTWORK", nil, 3)
            frame.Gap:SetTexture(getTexture("background", Styles[style].GapbarTex))
            frame.Gap:SetVertexColor(unpack(Styles[style].BorderColor))
        end
        frame.Gap:ClearAllPoints()
        frame.Gap:Show()

    elseif Styles[style].Backdrop then
        frame.MBBorder = addBorderFrame(frame.MBBorder, manabar, 2, frame)
        frame.MBBorder:SetFrameStrata("LOW")
        frame.MBShadow = dropShadow(frame.MBShadow, manabar, Styles[style].ShadowOutset + GridFrame.db.profile.borderSize + 4, frame)

    else
        --for 'None'
        --frame.MBShadow = dropShadow(frame.MBShadow, manabar, Styles[style].ShadowOutset + GridFrame.db.profile.borderSize + 1, frame)
    end

    bar:ClearAllPoints()
    if Styles[style].type ~= "Divide" then
        manabar:ClearAllPoints()
    end

    local b = GridFrame.db.profile.borderSize + 1

    if Styles[style].type == "Divide" then
        if side == "Right" then
            frame.Gap:SetSize(1, frameH - b * 2)
            frame.Gap:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -b - manabarW - 1, -b)
            bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", b, b)
            bar:SetPoint("TOPRIGHT", frame.Gap, "TOPRIGHT", -1, 0)
            manabar:SetOrientation("VERTICAL")
        elseif side == "Left" then
            frame.Gap:SetSize(1, frameH - b * 2)
            frame.Gap:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", b + manabarW + 1, b)
            bar:SetPoint("BOTTOMLEFT", frame.Gap, "BOTTOMRIGHT", 1, 0)
            bar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -b, -b)
            manabar:SetOrientation("VERTICAL")
        elseif side == "Bottom" then
            frame.Gap:SetSize(frameW - b * 2, 1)
            frame.Gap:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", b, b + manabarH + 1)
            bar:SetPoint("BOTTOMLEFT", frame.Gap, "TOPLEFT", 0, 1)
            bar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -b, -b)
            manabar:SetOrientation("HORIZONTAL")
        else
            frame.Gap:SetSize(frameW - b * 2, 1)
            frame.Gap:SetPoint("TOPLEFT", frame, "TOPLEFT", b, -b - manabarH - 1)
            bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", b, b)
            bar:SetPoint("TOPRIGHT", frame.Gap, "BOTTOMRIGHT", 0, -1)
            manabar:SetOrientation("HORIZONTAL")
        end

    elseif Styles[style].type == "Isolate" then
        local offset = Styles[style].offset
        if frame.MBBorder then
            local offset = (offset and offset < 6 or not offset) and 5 or offset or 0
        end
        frame.HBarBorder = addBorderFrame(frame.HBarBorder, bar, 2, frame)

        if side == "Right" then
            bar:SetPoint("TOPLEFT", frame, "TOPLEFT", b, -b)
            bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", b, b)
            manabar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -b, -b)
            bar:SetPoint("BOTTOMRIGHT", manabar, "BOTTOMLEFT", -offset, 0)
            manabar:SetOrientation("VERTICAL")
        elseif side == "Left" then
            manabar:SetPoint("TOPLEFT", frame, "TOPLEFT", b, -b)
            bar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -b, -b)
            bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -b, b)
            bar:SetPoint("BOTTOMLEFT", manabar, "BOTTOMRIGHT", offset, 0)
            manabar:SetOrientation("VERTICAL")
        elseif side == "Bottom" then
            bar:SetPoint("TOPLEFT", frame, "TOPLEFT", b, -b)
            manabar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", b, b)
            bar:SetPoint("BOTTOMRIGHT", manabar, "TOPRIGHT", 0, offset)
            manabar:SetOrientation("HORIZONTAL")
        else
            manabar:SetPoint("TOPLEFT", frame, "TOPLEFT", b, -b)
            bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", b, b)
            bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -b, b)
            bar:SetPoint("TOPRIGHT", manabar, "BOTTOMRIGHT", 0, -offset)
            manabar:SetOrientation("HORIZONTAL")
        end

    elseif Styles[style].type == "Overlap" then
        if frame.MBBorder then
            frame.MBBorder:SetFrameStrata("MEDIUM")
            frame.MBBorder:SetFrameLevel(bar:GetFrameLevel() + 1)
        end
        if not frame.NewMBG then
            frame.NewMBG = frame.MBBorder:CreateTexture(nil, "BORDER")
            frame.NewMBG:SetAllPoints(manabar)
            frame.NewMBG:SetTexture([[Interface\Addons\GridManaBars\GridBorderStyle\medias\normTex]])
        end
        manabar:SetFrameLevel(bar:GetFrameLevel() + 2)
        frame.HBarBorder = addBorderFrame(frame.HBarBorder, bar, 2, frame)

        if side == "Right" then
            bar:SetPoint("TOPLEFT", frame, "TOPLEFT", b, -b)
            bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -b - floor(b+manabarW/2), b)
            manabar:SetPoint("CENTER", bar, "RIGHT")
            manabar:SetPoint("RIGHT", frame, "RIGHT", -b, 0)
            manabar:SetHeight(manabarH * Styles[style].MBLengthPer)
            manabar:SetOrientation("VERTICAL")
        elseif side == "Left" then
            bar:SetPoint("TOPLEFT", frame, "TOPLEFT", b + floor(b+manabarW/2), -b)
            bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -b, b)
            manabar:SetPoint("CENTER", bar, "LEFT", b, 0)
            manabar:SetPoint("LEFT", frame, "LEFT", b, 0)
            manabar:SetHeight(manabarH * Styles[style].MBLengthPer)
            manabar:SetOrientation("VERTICAL")
        elseif side == "Bottom" then
            bar:SetPoint("TOPLEFT", frame, "TOPLEFT", b, -b)
            bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -b, b + floor(b+manabarH/2))
            manabar:SetPoint("CENTER", bar, "BOTTOM")
            manabar:SetPoint("BOTTOM", frame, "BOTTOM", 0, b)
            manabar:SetWidth(manabarW * Styles[style].MBLengthPer)
            manabar:SetOrientation("HORIZONTAL")
        else
            bar:SetPoint("TOPLEFT", frame, "TOPLEFT", b, - b - floor(b+manabarH/2))
            bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -b, b)
            manabar:SetPoint("CENTER", bar, "TOP")
            manabar:SetPoint("TOP", frame, "TOP", 0, -b)
            manabar:SetWidth(manabarW * Styles[style].MBLengthPer)
            manabar:SetOrientation("HORIZONTAL")
        end

    elseif Styles[style].type == "Layers" then
        manabar:SetOrientation("HORIZONTAL")
        local offset = Styles[style].offset
        manabar:SetFrameLevel(1)
        manabar.bg:SetColorTexture(0, 0, 0, 0)

        if not frame.NewMBG then
            frame.NewMBG = frame.MBBorder:CreateTexture(nil, "BORDER")
            frame.NewMBG:SetAllPoints(manabar)
            frame.NewMBG:SetTexture([[Interface\Addons\GridManaBars\GridBorderStyle\medias\normTex]])
        end
        frame.HBarBorder = addBorderFrame(frame.HBarBorder, bar, 2, frame)
        frame.HBarBorder:SetFrameStrata("MEDIUM")
        frame.HBarBorder:SetFrameLevel(2)

        if side == "Right" then
            --bottomright
            bar:SetPoint("TOPLEFT", frame, "TOPLEFT", b, -b)
            bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -offset, offset)
            manabar:SetPoint("TOPLEFT", frame, "TOPLEFT", offset, -offset)
            manabar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -b, b)
        elseif side == "Top" then
            --topright
            bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", b, b)
            bar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -offset, -offset)
            manabar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", offset, offset)
            manabar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -b, -b)
        elseif side == "Left" then
            --topleft
            bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -b, b)
            bar:SetPoint("TOPLEFT", frame, "TOPLEFT", offset, -offset)
            manabar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -offset, offset)
            manabar:SetPoint("TOPLEFT", frame, "TOPLEFT", b, -b)
        else
            --bottomleft
            bar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -b, -b)
            bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", offset, offset)
            manabar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -offset, -offset)
            manabar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", b, b)
        end
    end
end