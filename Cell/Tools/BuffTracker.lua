local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs
local LCG = LibStub("LibCustomGlow-1.0")
local LGI = LibStub:GetLibrary("LibGroupInfo")

local UnitIsConnected = UnitIsConnected
local UnitIsVisible = UnitIsVisible
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsUnit = UnitIsUnit
local UnitIsPlayer = UnitIsPlayer
local UnitGUID = UnitGUID
local UnitClassBase = UnitClassBase
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid

-------------------------------------------------
-- buffs
-------------------------------------------------
local buffs = {
    ["PWF"] = {["id"]=21562, ["glowColor"]={F:GetClassColor("PRIEST")}}, -- Power Word: Fortitude
    ["MotW"] = {["id"]=1126, ["glowColor"]={F:GetClassColor("DRUID")}}, -- Mark of the Wild
    ["AB"] = {["id"]=1459, ["glowColor"]={F:GetClassColor("MAGE")}}, -- Arcane Brilliance
    ["BS"] = {["id"]=6673, ["glowColor"]={F:GetClassColor("WARRIOR")}}, -- Battle Shout
}

do
    for _, t in pairs(buffs) do
        local name, _, icon = GetSpellInfo(t["id"])
        t["name"] = name
        t["icon"] = icon
    end
end

local order = {"PWF", "MotW", "AB", "BS"}

-------------------------------------------------
-- required buffs
-------------------------------------------------
local requiredBuffs = {
    [250] = "BS", -- Blood
    [251] = "BS", -- Frost
    [252] = "BS", -- Unholy

    [577] = "BS", -- Havoc
    [581] = "BS", -- Vengeance

    [102] = "AB", -- Balance
    [103] = "BS", -- Feral
    [104] = "BS", -- Guardian
    [105] = "AB", -- Restoration

    [253] = "BS", -- Beast Mastery
    [254] = "BS", -- Marksmanship
    [255] = "BS", -- Survival

    [62] = "AB", -- Arcane
    [63] = "AB", -- Fire
    [64] = "AB", -- Frost

    [268] = "BS", -- Brewmaster
    [269] = "BS", -- Windwalker
    [270] = "AB", -- Mistweaver

    [65] = "AB", -- Holy
    [66] = "BS", -- Protection
    [70] = "BS", -- Retribution

    [256] = "AB", -- Discipline
    [257] = "AB", -- Holy
    [258] = "AB", -- Shadow

    [259] = "BS", -- Assassination
    [260] = "BS", -- Outlaw
    [261] = "BS", -- Subtlety

    [262] = "AB", -- Elemental
    [263] = "BS", -- Enhancement
    [264] = "AB", -- Restoration

    [265] = "AB", -- Affliction
    [266] = "AB", -- Demonology
    [267] = "AB", -- Destruction

    [71] = "BS", -- Arms
    [72] = "BS", -- Fury
    [73] = "BS", -- Protection
}

-------------------------------------------------
-- vars
-------------------------------------------------
local enabled
local myUnit = ""
local hasBuffProvider

local available = {
    ["PWF"] = false,
    ["MotW"] = false,
    ["AB"] = false,
    ["BS"] = false,
}

local unaffected = {
    ["PWF"] = {},
    ["MotW"] = {},
    ["AB"] = {},
    ["BS"] = {},
}

local function Reset(which)
    if not which or which == "available" then
        for k, v in pairs(available) do
            available[k] = false
        end
        hasBuffProvider = false
    end

    if not which or which == "unaffected" then
        for k, v in pairs(unaffected) do
            wipe(unaffected[k])
        end
    end
end

function F:GetUnaffectedString(spell)
    local list = unaffected[spell]
    local buff = buffs[spell]["name"]

    local players = {}
    for unit in pairs(list) do
        local name = UnitName(unit)
        tinsert(players, name)
    end

    if #players == 0 then
        return
    elseif #players <= 10 then
        return L["Missing Buff"].." ("..buff.."): "..table.concat(players, ", ")
    else
        return L["Missing Buff"].." ("..buff.."): "..L["many"]
    end
end

-------------------------------------------------
-- frame
-------------------------------------------------
local buffTrackerFrame = CreateFrame("Frame", "CellBuffTrackerFrame", Cell.frames.mainFrame, "BackdropTemplate")
Cell.frames.buffTrackerFrame = buffTrackerFrame
P:Size(buffTrackerFrame, 102, 50)
buffTrackerFrame:SetPoint("BOTTOMLEFT", UIParent, "CENTER")
buffTrackerFrame:SetClampedToScreen(true)
buffTrackerFrame:SetMovable(true)
buffTrackerFrame:RegisterForDrag("LeftButton")
buffTrackerFrame:SetScript("OnDragStart", function()
    buffTrackerFrame:StartMoving()
    buffTrackerFrame:SetUserPlaced(false)
end)
buffTrackerFrame:SetScript("OnDragStop", function()
    buffTrackerFrame:StopMovingOrSizing()
    P:SavePosition(buffTrackerFrame, CellDB["tools"]["buffTracker"][2])
end)

-------------------------------------------------
-- mover
-------------------------------------------------
buffTrackerFrame.moverText = buffTrackerFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
buffTrackerFrame.moverText:SetPoint("TOP", 0, -3)
buffTrackerFrame.moverText:SetText(L["Mover"])
buffTrackerFrame.moverText:Hide()

local fakeIconsFrame = CreateFrame("Frame", nil, buffTrackerFrame)
P:Point(fakeIconsFrame, "BOTTOMLEFT", buffTrackerFrame)
P:Point(fakeIconsFrame, "TOPRIGHT", buffTrackerFrame, "BOTTOMRIGHT", 0, 32)
fakeIconsFrame:EnableMouse(true)
fakeIconsFrame:SetFrameLevel(buffTrackerFrame:GetFrameLevel()+10)
fakeIconsFrame:Hide()

local fakeIcons = {}
local function CreateFakeIcon(spellIcon)
    local bg = fakeIconsFrame:CreateTexture(nil, "BORDER")
    bg:SetColorTexture(0, 0, 0, 1)
    P:Size(bg, 32, 32)
    
    local icon = fakeIconsFrame:CreateTexture(nil, "ARTWORK")
    icon:SetTexture(spellIcon)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    P:Point(icon, "TOPLEFT", bg, "TOPLEFT", 1, -1)
    P:Point(icon, "BOTTOMRIGHT", bg, "BOTTOMRIGHT", -1, 1)

    function bg:UpdatePixelPerfect()
        P:Resize(bg)
        P:Repoint(bg)
        P:Repoint(icon)
    end

    return bg
end

do
    for _, k in ipairs(order) do
        tinsert(fakeIcons, CreateFakeIcon(buffs[k]["icon"]))
        local i = #fakeIcons
        
        if i == 1 then
            P:Point(fakeIcons[i], "BOTTOMLEFT")
        else
            P:Point(fakeIcons[i], "BOTTOMLEFT", fakeIcons[i-1], "BOTTOMRIGHT", 3, 0)
        end
    end
end

local function ShowMover(show)
    if show then
        if not CellDB["tools"]["buffTracker"][1] then return end
        buffTrackerFrame:EnableMouse(true)
        buffTrackerFrame.moverText:Show()
        Cell:StylizeFrame(buffTrackerFrame, {0, 1, 0, 0.4}, {0, 0, 0, 0})
        fakeIconsFrame:Show()
    else
        buffTrackerFrame:EnableMouse(false)
        buffTrackerFrame.moverText:Hide()
        Cell:StylizeFrame(buffTrackerFrame, {0, 0, 0, 0}, {0, 0, 0, 0})
        fakeIconsFrame:Hide()
    end
end
Cell:RegisterCallback("ShowMover", "BuffTracker_ShowMover", ShowMover)

-------------------------------------------------
-- buttons
-------------------------------------------------
local sendChannel
local function UpdateSendChannel()
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        sendChannel = "INSTANCE_CHAT"
    elseif IsInRaid() then
        sendChannel = "RAID"
    else
        sendChannel = "PARTY"
    end
end

local function CreateBuffButton(parent, size, spell, icon, index)
    local b = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate,BackdropTemplate")
    if parent then b:SetFrameLevel(parent:GetFrameLevel()+1) end
    P:Size(b, size[1], size[2])
    
    b:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    b:SetBackdropBorderColor(0, 0, 0, 1)

    b:RegisterForClicks("LeftButtonUp", "RightButtonUp", "LeftButtonDown", "RightButtonDown") -- NOTE: ActionButtonUseKeyDown will affect this
    b:SetAttribute("type1", "spell")
    b:SetAttribute("spell", spell)
    b:HookScript("OnClick", function(self, button, down)
        if button == "RightButton" then
            local msg = F:GetUnaffectedString(index)
            if msg then
                UpdateSendChannel()
                SendChatMessage(msg, sendChannel)
            end
        end
    end)

    b.texture = b:CreateTexture(nil, "OVERLAY")
    P:Point(b.texture, "TOPLEFT", b, "TOPLEFT", 1, -1)
    P:Point(b.texture, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, 1)
    b.texture:SetTexture(icon)
    b.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    b.count = b:CreateFontString(nil, "OVERLAY")
    P:Point(b.count, "TOPLEFT", b.texture, "TOPLEFT", 2, -2)
    b.count:SetFont(GameFontNormal:GetFont(), 14, "OUTLINE")
    b.count:SetShadowColor(0, 0, 0)
    b.count:SetShadowOffset(0, 0)
    b.count:SetTextColor(1, 0, 0)

    b:SetScript("OnLeave", function()
        CellTooltip:Hide()
    end)

    function b:SetTooltips(list)
        b:SetScript("OnEnter", function()
            if F:Getn(list) ~= 0 then
                CellTooltip:SetOwner(b, "ANCHOR_TOPLEFT", 0, 3)
                CellTooltip:AddLine(L["Unaffected"])
                for unit in pairs(list) do
                    local class = UnitClassBase(unit)
                    local name = UnitName(unit)
                    if class and name then
                        CellTooltip:AddLine(F:GetClassColorStr(class)..name.."|r")
                    end
                end
                CellTooltip:Show()
            end
        end)
    end

    function b:SetDesaturated(flag)
        b.texture:SetDesaturated(flag)
    end

    function b:StartGlow(glowType, ...)
        if glowType == "Normal" then
            LCG.PixelGlow_Stop(b)
            LCG.AutoCastGlow_Stop(b)
            LCG.ButtonGlow_Start(b, ...)
        elseif glowType == "Pixel" then
            LCG.ButtonGlow_Stop(b)
            LCG.AutoCastGlow_Stop(b)
            -- color, N, frequency, length, thickness
            LCG.PixelGlow_Start(b, ...)
        elseif glowType == "Shine" then
            LCG.ButtonGlow_Stop(b)
            LCG.PixelGlow_Stop(b)
            LCG.AutoCastGlow_Stop(b)
            -- color, N, frequency, scale
            LCG.AutoCastGlow_Start(b, ...)
        end
    end

    function b:StopGlow()
        LCG.ButtonGlow_Stop(b)
        LCG.PixelGlow_Stop(b)
        LCG.AutoCastGlow_Stop(b)
    end

    function b:Reset()
        b.texture:SetDesaturated(false)
        b.count:SetText("")
        b:SetAlpha(1)
        b:StopGlow()
    end

    function b:UpdatePixelPerfect()
        P:Resize(b)
        P:Repoint(b)
        b:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
        b:SetBackdropBorderColor(0, 0, 0, 1)

        P:Repoint(b.texture)
        P:Repoint(b.count)
    end

    return b
end

local buttons = {}

do
    for _, k in ipairs(order) do
        buttons[k] = CreateBuffButton(buffTrackerFrame, {32, 32}, buffs[k]["name"], buffs[k]["icon"], k)
        buttons[k]:Hide()
        buttons[k]:SetTooltips(unaffected[k])
    end
end

local function UpdateButtons()
    for _, k in pairs(order) do
        if available[k] then
            local n = F:Getn(unaffected[k])
            if n == 0 then
                buttons[k].count:SetText("")
                buttons[k]:SetAlpha(0.5)
                buttons[k]:StopGlow()
            else
                buttons[k].count:SetText(n)
                buttons[k]:SetAlpha(1)
                if unaffected[k][myUnit] then
                    -- color, N, frequency, length, thickness
                    buttons[k]:StartGlow("Pixel", buffs[k]["glowColor"], 8, 0.25, P:Scale(8), P:Scale(2))
                else
                    buttons[k]:StopGlow()
                end
            end
        end
    end
end

local function AnchorButtons()
    if InCombatLockdown() then
        buffTrackerFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    else
        local last
        for _, k in pairs(order) do
            buttons[k]:ClearAllPoints()
            if available[k] then
                buttons[k]:Show()
                if last then
                    buttons[k]:SetPoint("BOTTOMLEFT", last, "BOTTOMRIGHT", 3, 0)
                else
                    buttons[k]:SetPoint("BOTTOMLEFT")
                end
                last = buttons[k]
            else
                buttons[k]:Hide()
                buttons[k]:Reset()
            end
        end
    end
end

local function ResizeButtons()
    if InCombatLockdown() then
        buffTrackerFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    else
        local size = CellDB["tools"]["buffTracker"][3]
        for _, i in pairs(fakeIcons) do
            P:Size(i, size, size)
        end
        for _, b in pairs(buttons) do
            P:Size(b, size, size)
        end

        local n = F:Getn(buttons)
        P:Size(buffTrackerFrame, n * size + (n - 1) * 3, size + 18)
    end
end

-------------------------------------------------
-- check
-------------------------------------------------
local function CheckUnit(unit, updateBtn)
    -- print("CheckUnit", unit)
    if not hasBuffProvider then return end

    if UnitIsConnected(unit) and UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit) then
        local info = LGI:GetCachedInfo(UnitGUID(unit))
        local spec = info and info.specId or ""
        local required = requiredBuffs[spec]

        for k, v in pairs(available) do
            if v ~= false and (required == k or k == "PWF" or k == "MotW") then
                if not F:FindAuraById(unit, "BUFF", buffs[k]["id"]) then
                    unaffected[k][unit] = true
                else
                    unaffected[k][unit] = nil
                end
            end
        end
    else
        for k, t in pairs(unaffected) do
            t[unit] = nil
        end
    end
    
    if updateBtn then UpdateButtons() end
end

local function IterateAllUnits()
    Reset("available")
    myUnit = ""

    for unit in F:IterateGroupMembers() do
        if UnitIsConnected(unit) and UnitIsVisible(unit) then
            if UnitClassBase(unit) == "PRIEST" then
                available["PWF"] = true
                hasBuffProvider = true
            end
            if UnitClassBase(unit) == "DRUID" then
                available["MotW"] = true
                hasBuffProvider = true
            end
            if UnitClassBase(unit) == "MAGE" then
                available["AB"] = true
                hasBuffProvider = true
            end
            if UnitClassBase(unit) == "WARRIOR" then
                available["BS"] = true
                hasBuffProvider = true
            end

            if UnitIsUnit("player", unit) then
                myUnit = unit
            end
        end
    end

    AnchorButtons()
    
    Reset("unaffected")

    for unit in F:IterateGroupMembers() do
        CheckUnit(unit)
    end

    UpdateButtons()
end

-------------------------------------------------
-- events
-------------------------------------------------
function buffTrackerFrame:UnitUpdated(event, guid, unit, info)
    -- print(event, guid, unit, info.specId)
    if unit == "player" then 
        if UnitIsUnit("player", myUnit) then CheckUnit(myUnit, true) end
    elseif UnitIsPlayer(unit) then -- ignore pets
        CheckUnit(unit, true)
    end
end

function buffTrackerFrame:PLAYER_ENTERING_WORLD()
    buffTrackerFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
    buffTrackerFrame:GROUP_ROSTER_UPDATE()
end

local timer
function buffTrackerFrame:GROUP_ROSTER_UPDATE(immediate)
    if timer then timer:Cancel() end
    if IsInGroup() then
        buffTrackerFrame:RegisterEvent("READY_CHECK")
        buffTrackerFrame:RegisterEvent("UNIT_FLAGS")
        buffTrackerFrame:RegisterEvent("PLAYER_UNGHOST")
        buffTrackerFrame:RegisterEvent("UNIT_AURA")
    else
        buffTrackerFrame:UnregisterEvent("READY_CHECK")
        buffTrackerFrame:UnregisterEvent("UNIT_FLAGS")
        buffTrackerFrame:UnregisterEvent("PLAYER_UNGHOST")
        buffTrackerFrame:UnregisterEvent("UNIT_AURA")

        Reset()
        AnchorButtons()
        return
    end

    if immediate then
        IterateAllUnits()
    else
        timer = C_Timer.NewTimer(2, IterateAllUnits)
    end
end

function buffTrackerFrame:READY_CHECK()
    buffTrackerFrame:GROUP_ROSTER_UPDATE(true)
end

function buffTrackerFrame:UNIT_FLAGS()
    buffTrackerFrame:GROUP_ROSTER_UPDATE()
end

function buffTrackerFrame:PLAYER_UNGHOST()
    buffTrackerFrame:GROUP_ROSTER_UPDATE()
end

function buffTrackerFrame:UNIT_AURA(unit)
    if IsInRaid() then
        if string.match(unit, "raid%d") then
            CheckUnit(unit, true)
        end
    else
        if string.match(unit, "party%d") or unit=="player" then
            CheckUnit(unit, true)
        end
    end
end

function buffTrackerFrame:PLAYER_REGEN_ENABLED()
    buffTrackerFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
    AnchorButtons()
    ResizeButtons()
end

buffTrackerFrame:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

-------------------------------------------------
-- functions
-------------------------------------------------
local function UpdateTools(which)
    if not which or which == "buffTracker" then
        if CellDB["tools"]["buffTracker"][1] then
            buffTrackerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
            buffTrackerFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
            LGI.RegisterCallback(buffTrackerFrame, "GroupInfo_Update", "UnitUpdated") 

            if not enabled and which == "buffTracker" then -- already in world, manually enabled
                buffTrackerFrame:GROUP_ROSTER_UPDATE(true)
            end
            enabled = true
            if Cell.vars.showMover then
                ShowMover(true)
            end
        else
            buffTrackerFrame:UnregisterAllEvents()
            LGI.UnregisterCallback(buffTrackerFrame, "GroupInfo_Update")
            
            Reset()
            myUnit = ""
            AnchorButtons()

            enabled = false
            ShowMover(false)
        end

        ResizeButtons()
    end

    if not which then -- position
        P:LoadPosition(buffTrackerFrame, CellDB["tools"]["buffTracker"][2])
    end
end
Cell:RegisterCallback("UpdateTools", "BuffTracker_UpdateTools", UpdateTools)

local function UpdatePixelPerfect()
    P:Resize(buffTrackerFrame)

    for _, i in pairs(fakeIcons) do
        i:UpdatePixelPerfect()
    end

    for _, b in pairs(buttons) do
        b:UpdatePixelPerfect()
    end
end
Cell:RegisterCallback("UpdatePixelPerfect", "BuffTracker_UpdatePixelPerfect", UpdatePixelPerfect)