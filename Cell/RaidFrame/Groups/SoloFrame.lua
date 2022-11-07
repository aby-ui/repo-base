local _, Cell = ...
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local soloFrame = CreateFrame("Frame", "CellSoloFrame", Cell.frames.mainFrame, "SecureFrameTemplate")
Cell.frames.soloFrame = soloFrame
soloFrame:SetAllPoints(Cell.frames.mainFrame)
-- RegisterAttributeDriver(soloFrame, "state-visibility", "[group] hide; show")

local playerButton = CreateFrame("Button", soloFrame:GetName().."Player", soloFrame, "CellUnitButtonTemplate")
playerButton:SetAttribute("unit", "player")
playerButton:SetPoint("TOPLEFT")
playerButton:Show()
Cell.unitButtons.solo["player"] = playerButton

local petButton = CreateFrame("Button", soloFrame:GetName().."Pet", soloFrame, "CellUnitButtonTemplate")
petButton:SetAttribute("unit", "pet")
RegisterAttributeDriver(petButton, "state-visibility", "[nopet] hide; [vehicleui] hide; show")
Cell.unitButtons.solo["pet"] = petButton

local init
local function SoloFrame_UpdateLayout(layout, which)
    -- if layout ~= Cell.vars.currentLayout then return end
    if Cell.vars.groupType ~= "solo" and init then return end
    init = true
    layout = CellLayoutAutoSwitchTable[Cell.vars.playerSpecRole]["party"]
    layout = CellDB["layouts"][layout]

    if not which or which == "size" then
        local width, height = unpack(layout["size"])
        P:Size(playerButton, width, height)
        if layout["pet"][4] then
            P:Size(petButton, layout["pet"][5][1], layout["pet"][5][2])
        else
            P:Size(petButton, width, height)
        end
    end

    if which == "petSize" then
        if layout["pet"][4] then
            P:Size(petButton, layout["pet"][5][1], layout["pet"][5][2])
        else
            P:Size(petButton, layout["size"][1], layout["size"][2])
        end
    end

    -- NOTE: SetOrientation BEFORE SetPowerSize
    if not which or which == "barOrientation" then
        playerButton.func.SetOrientation(unpack(layout["barOrientation"]))
        petButton.func.SetOrientation(unpack(layout["barOrientation"]))
    end
    
    if not which or which == "power" or which == "barOrientation" then
        playerButton.func.SetPowerSize(layout["powerSize"])
        petButton.func.SetPowerSize(layout["powerSize"])
    end


    if not which or which == "spacing" or which == "orientation" or which == "anchor" then
        petButton:ClearAllPoints()
        if layout["orientation"] == "vertical" then
            -- anchor
            local point, anchorPoint, unitSpacing
            if layout["anchor"] == "BOTTOMLEFT" then
                point, anchorPoint = "BOTTOMLEFT", "TOPLEFT"
                unitSpacing = layout["spacing"]
            elseif layout["anchor"] == "BOTTOMRIGHT" then
                point, anchorPoint = "BOTTOMRIGHT", "TOPRIGHT"
                unitSpacing = layout["spacing"]
            elseif layout["anchor"] == "TOPLEFT" then
                point, anchorPoint = "TOPLEFT", "BOTTOMLEFT"
                unitSpacing = -layout["spacing"]
            elseif layout["anchor"] == "TOPRIGHT" then
                point, anchorPoint = "TOPRIGHT", "BOTTOMRIGHT"
                unitSpacing = -layout["spacing"]
            end

            petButton:SetPoint(point, playerButton, anchorPoint, 0, unitSpacing)
        else
            -- anchor
            local point, anchorPoint, unitSpacing
            if layout["anchor"] == "BOTTOMLEFT" then
                point, anchorPoint = "BOTTOMLEFT", "BOTTOMRIGHT"
                unitSpacing = layout["spacing"]
            elseif layout["anchor"] == "BOTTOMRIGHT" then
                point, anchorPoint = "BOTTOMRIGHT", "BOTTOMLEFT"
                unitSpacing = -layout["spacing"]
            elseif layout["anchor"] == "TOPLEFT" then
                point, anchorPoint = "TOPLEFT", "TOPRIGHT"
                unitSpacing = layout["spacing"]
            elseif layout["anchor"] == "TOPRIGHT" then
                point, anchorPoint = "TOPRIGHT", "TOPLEFT"
                unitSpacing = -layout["spacing"]
            end

            petButton:SetPoint(point, playerButton, anchorPoint, unitSpacing, 0)
        end
    end
end
Cell:RegisterCallback("UpdateLayout", "SoloFrame_UpdateLayout", SoloFrame_UpdateLayout)

local function SoloFrame_UpdateVisibility(which)
    F:Debug("|cffff7fffUpdateVisibility:|r "..(which or "all"))

    if not which or which == "solo" then
        if CellDB["general"]["showSolo"] then
            RegisterAttributeDriver(soloFrame, "state-visibility", "[group] hide; show")
        else
            UnregisterAttributeDriver(soloFrame, "state-visibility")
            soloFrame:Hide()
        end
    end
end
Cell:RegisterCallback("UpdateVisibility", "SoloFrame_UpdateVisibility", SoloFrame_UpdateVisibility)