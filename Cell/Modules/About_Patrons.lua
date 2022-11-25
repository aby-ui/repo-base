local _, Cell = ...
local F = Cell.funcs

-------------------------------------------------
-- list
-------------------------------------------------
function F:GetPatrons()
    local str = ""
    local n = #Cell.patrons
    for i = 1, n do
        str = str .. Cell.patrons[i][1]
        if i ~= n then
            str = str .. "\n"
        end
    end
    return str
end

-------------------------------------------------
-- highlight
-------------------------------------------------
-- function F:IsPatron(fullName)
--     return fullName and Cell.wowPatrons[fullName]
-- end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("FIRST_FRAME_RENDERED")

function StopRainbow(unit)
    local b = F:GetUnitButtonByUnit(unit)
    if b then
        local fs = b.indicators.nameText.name
        -- stop rainbow
        fs.rainbow = nil
        if fs.updater then
            fs.updater:SetScript("OnUpdate", nil)
            fs:GetParent():UpdateName()
        end
        -- stop timer
        if fs.timer then
            fs.timer:Cancel()
            fs.timer = nil
        end
    end
end

local function StartRainbow(unit)
    local b = F:GetUnitButtonByUnit(unit)
    if b then
        local fs = b.indicators.nameText.name
        Cell:StartRainbowText(fs)
        -- reset timer
        if fs.timer then
            fs.timer:Cancel()
        end
        fs.timer = C_Timer.NewTimer(3, function()
            StopRainbow(unit)
        end)
    end
end

local function Check()
    if IsInGroup() then
        for unit in F:IterateGroupMembers() do
            local fullName = F:UnitFullName(unit)
            if Cell.wowPatrons[fullName] then
                StartRainbow(unit)
            else
                StopRainbow(unit)
            end
        end
    else
        if Cell.wowPatrons[Cell.vars.playerNameFull] then
            StartRainbow("player")
        end
    end
end

local timer, members
eventFrame:SetScript("OnEvent", function(self, event)
    if event == "FIRST_FRAME_RENDERED" then
        eventFrame:UnregisterEvent("FIRST_FRAME_RENDERED")
        eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    end

    if timer then
        timer:Cancel()
        timer = nil
    end

    if InCombatLockdown() then return end

    local newMembers = GetNumGroupMembers()
    if members ~= newMembers then
        members = newMembers
        timer = C_Timer.NewTimer(5, function()
            Check()
        end)
    end
end)