local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local powerFilters = Cell:CreateFrame("CellOptionsFrame_PowerFilters", Cell.frames.layoutsTab, 270, 205)
Cell.frames.powerFilters = powerFilters
powerFilters:SetFrameStrata("DIALOG")
powerFilters:SetFrameLevel(50)

-------------------------------------------------
-- filters
-------------------------------------------------
local dkF, dhF, druidF, hunterF, mageF, monkF, paladinF, priestF, rogueF, shamanF, warlockF, warriorF, petF, vehicleF, npcF

local function CreateFilters()
    dkF =  Cell:CreatePowerFilter(powerFilters, "DEATHKNIGHT", {"TANK", "DAMAGER"}, 125, 20, 20)
    druidF = Cell:CreatePowerFilter(powerFilters, "DRUID", {"TANK", "HEALER", "DAMAGER"}, 125, 20, 20)
    hunterF = Cell:CreatePowerFilter(powerFilters, "HUNTER", {"DAMAGER"}, 125, 20, 20)
    mageF = Cell:CreatePowerFilter(powerFilters, "MAGE", {"DAMAGER"}, 125, 20, 20)
    paladinF = Cell:CreatePowerFilter(powerFilters, "PALADIN", {"TANK", "HEALER", "DAMAGER"}, 125, 20, 20)
    priestF = Cell:CreatePowerFilter(powerFilters, "PRIEST", {"HEALER", "DAMAGER"}, 125, 20, 20)
    rogueF = Cell:CreatePowerFilter(powerFilters, "ROGUE", {"DAMAGER"}, 125, 20, 20)
    shamanF = Cell:CreatePowerFilter(powerFilters, "SHAMAN", {"HEALER", "DAMAGER"}, 125, 20, 20)
    warlockF = Cell:CreatePowerFilter(powerFilters, "WARLOCK", {"DAMAGER"}, 125, 20, 20)
    warriorF = Cell:CreatePowerFilter(powerFilters, "WARRIOR", {"TANK", "DAMAGER"}, 125, 20, 20)
    petF = Cell:CreatePowerFilter(powerFilters, "PET", {"DAMAGER"}, 125, 20, 20)
    vehicleF = Cell:CreatePowerFilter(powerFilters, "VEHICLE", {"DAMAGER"}, 125, 20, 20)
    npcF = Cell:CreatePowerFilter(powerFilters, "NPC", {"DAMAGER"}, 125, 20, 20)

    if Cell.isRetail then
        P:Height(powerFilters, 205)

        dhF = Cell:CreatePowerFilter(powerFilters, "DEMONHUNTER", {"TANK", "DAMAGER"}, 125, 20, 20)
        monkF = Cell:CreatePowerFilter(powerFilters, "MONK", {"TANK", "HEALER", "DAMAGER"}, 125, 20, 20)

        dkF:SetPoint("TOPLEFT", 5, -5)
        dhF:SetPoint("TOPLEFT", 140, -5)
        druidF:SetPoint("TOPLEFT", dkF, "BOTTOMLEFT", 0, -5)
        hunterF:SetPoint("TOPLEFT", dhF, "BOTTOMLEFT", 0, -5)
        mageF:SetPoint("TOPLEFT", druidF, "BOTTOMLEFT", 0, -5)
        monkF:SetPoint("TOPLEFT", hunterF, "BOTTOMLEFT", 0, -5)
        paladinF:SetPoint("TOPLEFT", mageF, "BOTTOMLEFT", 0, -5)
        priestF:SetPoint("TOPLEFT", monkF, "BOTTOMLEFT", 0, -5)
        rogueF:SetPoint("TOPLEFT", paladinF, "BOTTOMLEFT", 0, -5)
        shamanF:SetPoint("TOPLEFT", priestF, "BOTTOMLEFT", 0, -5)
        warlockF:SetPoint("TOPLEFT", rogueF, "BOTTOMLEFT", 0, -5)
        warriorF:SetPoint("TOPLEFT", shamanF, "BOTTOMLEFT", 0, -5)
        petF:SetPoint("TOPLEFT", warlockF, "BOTTOMLEFT", 0, -5)
        vehicleF:SetPoint("TOPLEFT", warriorF, "BOTTOMLEFT", 0, -5)
        npcF:SetPoint("TOPLEFT", petF, "BOTTOMLEFT", 0, -5)
        
    elseif Cell.isWrath then
        P:Height(powerFilters, 180)

        dkF:SetPoint("TOPLEFT", 5, -5)
        druidF:SetPoint("TOPLEFT", 140, -5)
        hunterF:SetPoint("TOPLEFT", dkF, "BOTTOMLEFT", 0, -5)
        mageF:SetPoint("TOPLEFT", druidF, "BOTTOMLEFT", 0, -5)
        paladinF:SetPoint("TOPLEFT", hunterF, "BOTTOMLEFT", 0, -5)
        priestF:SetPoint("TOPLEFT", mageF, "BOTTOMLEFT", 0, -5)
        rogueF:SetPoint("TOPLEFT", paladinF, "BOTTOMLEFT", 0, -5)
        shamanF:SetPoint("TOPLEFT", priestF, "BOTTOMLEFT", 0, -5)
        warlockF:SetPoint("TOPLEFT", rogueF, "BOTTOMLEFT", 0, -5)
        warriorF:SetPoint("TOPLEFT", shamanF, "BOTTOMLEFT", 0, -5)
        petF:SetPoint("TOPLEFT", warlockF, "BOTTOMLEFT", 0, -5)
        vehicleF:SetPoint("TOPLEFT", warriorF, "BOTTOMLEFT", 0, -5)
        npcF:SetPoint("TOPLEFT", petF, "BOTTOMLEFT", 0, -5)
    end
end

-------------------------------------------------
-- scripts
-------------------------------------------------
powerFilters:SetScript("OnHide", function()
    powerFilters:Hide()
    Cell.frames.layoutsTab.mask:Hide()
    Cell.frames.layoutsTab.powerFilterBtn:SetFrameStrata("HIGH")
end)

local init
function F:ShowPowerFilters(selectedLayout, selectedLayoutTable)
    if not init then
        init = true
        powerFilters:UpdatePixelPerfect()
        powerFilters:SetBackdropBorderColor(unpack(Cell:GetAccentColorTable()))
        CreateFilters()
    end

    if powerFilters:IsShown() then
        powerFilters:Hide()
        Cell.frames.layoutsTab.powerFilterBtn:SetFrameStrata("HIGH")
    else
        powerFilters:Show()
        Cell.frames.layoutsTab.powerFilterBtn:SetFrameStrata("DIALOG")
        Cell.frames.layoutsTab.mask:Show()
        -- load db
        dkF:LoadConfig(selectedLayout, selectedLayoutTable)
        druidF:LoadConfig(selectedLayout, selectedLayoutTable)
        hunterF:LoadConfig(selectedLayout, selectedLayoutTable)
        mageF:LoadConfig(selectedLayout, selectedLayoutTable)
        paladinF:LoadConfig(selectedLayout, selectedLayoutTable)
        priestF:LoadConfig(selectedLayout, selectedLayoutTable)
        rogueF:LoadConfig(selectedLayout, selectedLayoutTable)
        shamanF:LoadConfig(selectedLayout, selectedLayoutTable)
        warlockF:LoadConfig(selectedLayout, selectedLayoutTable)
        warriorF:LoadConfig(selectedLayout, selectedLayoutTable)
        petF:LoadConfig(selectedLayout, selectedLayoutTable)
        vehicleF:LoadConfig(selectedLayout, selectedLayoutTable)
        npcF:LoadConfig(selectedLayout, selectedLayoutTable)

        if Cell.isRetail then
            dhF:LoadConfig(selectedLayout, selectedLayoutTable)
            monkF:LoadConfig(selectedLayout, selectedLayoutTable)
        end
    end
end