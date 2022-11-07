local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local I = Cell.iFuncs

-------------------------------------------------
-- events
-------------------------------------------------
local nameplates = {
    -- nameplateUnitId = true,
}

local nameplateTargets = {
    -- nameplateUnitId = targetGUID,
}

local counter = {
    -- friendGUID = {enemyGUID=true, ...},
}

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)


function eventFrame:NAME_PLATE_UNIT_REMOVED(unit)
    nameplates[unit] = nil
    nameplateTargets[unit] = nil
end

function eventFrame:NAME_PLATE_UNIT_ADDED(unit)
    if not (UnitIsPlayer(unit) and UnitIsEnemy(unit, "player")) then return end
    nameplates[unit] = true
end

local ticker
local function StartTicker()
    if ticker then ticker:Cancel() end
    ticker = C_Timer.NewTicker(0.25, function()
        -- reset
        for _, ct in pairs(counter) do
            wipe(ct)
        end

        -- check & calculate
        for unit in pairs(nameplates) do
            local target = UnitGUID(unit.."target")
            
            if not target then -- no target
                nameplateTargets[unit] = nil
            elseif not Cell.vars.guids[target] then -- target doesn't exists in player's group
                nameplateTargets[unit] = nil
                counter[target] = nil
            else
                nameplateTargets[unit] = target
            end

            target = nameplateTargets[unit]
            if target and Cell.vars.guids[target] then -- valid target exists
                if not counter[target] then counter[target] = {} end -- init
                counter[target][unit] = true
            end
        end

        -- update indicator
        for guid in pairs(Cell.vars.guids) do
            local b1, b2 = F:GetUnitButtonByGUID(guid)
            if b1 then
                if counter[guid] then
                    b1.indicators.targetCounter:SetCount(F:Getn(counter[guid]))
                else
                    b1.indicators.targetCounter:SetCount(0)
                end
            end
            if b2 then
                if counter[guid] then
                    b2.indicators.targetCounter:SetCount(F:Getn(counter[guid]))
                else
                    b2.indicators.targetCounter:SetCount(0)
                end
            end
        end
    end)
end

local function StopTicker()
    if ticker then ticker:Cancel() end
    ticker = nil
end

local counterEnabled
function eventFrame:PLAYER_ENTERING_WORLD()
    -- reset
    wipe(nameplates)
    wipe(counter)
    F:IterateAllUnitButtons(function(b)
        b.indicators.targetCounter:SetCount(0)
    end, true)

    local isIn, iType = IsInInstance()
    if counterEnabled and (iType == "pvp" or iType == "arena") then
        eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
        StartTicker()
    else
        eventFrame:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
        eventFrame:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
        StopTicker()
    end
end

function I:EnableTargetCounter(enabled)
    if enabled then
        eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
        counterEnabled = true
    else
        eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
        counterEnabled = false
    end
    eventFrame:PLAYER_ENTERING_WORLD() -- check now
    -- texplore(nameplateTargets)
end

-------------------------------------------------
-- CreateTargetCounter
-------------------------------------------------
function I:CreateTargetCounter(parent)
    local targetCounter = CreateFrame("Frame", parent:GetName().."TargetCounter", parent)
    parent.indicators.targetCounter = targetCounter
    targetCounter:Hide()

    local text = targetCounter:CreateFontString(nil, "OVERLAY", "CELL_FONT_STATUS")
    targetCounter.text = text
    -- stack:SetJustifyH("RIGHT")
    text:SetPoint("CENTER", 1, 0)

    function targetCounter:SetFont(font, size, flags)
        if not string.find(strlower(font), ".ttf") then font = F:GetFont(font) end

        if flags == "Shadow" then
            text:SetFont(font, size, "")
            text:SetShadowOffset(1, -1)
            text:SetShadowColor(0, 0, 0, 1)
        else
            if flags == "None" then
                flags = ""
            elseif flags == "Outline" then
                flags = "OUTLINE"
            else
                flags = "OUTLINE, MONOCHROME"
            end
            text:SetFont(font, size, flags)
            text:SetShadowOffset(0, 0)
            text:SetShadowColor(0, 0, 0, 0)
        end

        local point = targetCounter:GetPoint(1)
        text:ClearAllPoints()
        if string.find(point, "LEFT") then
            text:SetPoint("LEFT")
        elseif string.find(point, "RIGHT") then
            text:SetPoint("RIGHT")
        else
            text:SetPoint("CENTER")
        end
        targetCounter:SetSize(size+3, size+3)
    end

    targetCounter.OriginalSetPoint = targetCounter.SetPoint
    function targetCounter:SetPoint(point, relativeTo, relativePoint, x, y)
        text:ClearAllPoints()
        if string.find(point, "LEFT") then
            text:SetPoint("LEFT")
        elseif string.find(point, "RIGHT") then
            text:SetPoint("RIGHT")
        else
            text:SetPoint("CENTER")
        end
        targetCounter:OriginalSetPoint(point, relativeTo, relativePoint, x, y)
    end

    function targetCounter:SetCount(n)
        if n == 0 then
            targetCounter:Hide()
        else
            targetCounter:Show()
        end
        text:SetText(n)
    end

    function targetCounter:SetColor(r, g, b)
        text:SetTextColor(r, g, b)
    end
end