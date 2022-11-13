local _, Cell = ...
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local partyFrame = CreateFrame("Frame", "CellPartyFrame", Cell.frames.mainFrame, "SecureFrameTemplate")
Cell.frames.partyFrame = partyFrame
partyFrame:SetAllPoints(Cell.frames.mainFrame)

local header = CreateFrame("Frame", "CellPartyFrameHeader", partyFrame, "SecureGroupHeaderTemplate")
header:SetAttribute("template", "CellUnitButtonTemplate")

function header:UpdateButtonUnits(bName, unit)
    if not unit then return end
    
    _G[bName].unitid = unit -- OmniCD

    local petUnit
    if unit == "player" then
        petUnit = "pet"
    else
        petUnit = string.gsub(unit, "party", "partypet")
    end
    Cell.unitButtons.party.units[unit] = _G[bName]
    Cell.unitButtons.party.units[petUnit] = _G[bName].petButton
end

header:SetAttribute("initialConfigFunction", [[
    RegisterUnitWatch(self)

    local header = self:GetParent()
    self:SetWidth(header:GetAttribute("buttonWidth") or 66)
    self:SetHeight(header:GetAttribute("buttonHeight") or 46)
]])

header:SetAttribute("_initialAttributeNames", "refreshUnitChange")
header:SetAttribute("_initialAttribute-refreshUnitChange", [[
    local unit = self:GetAttribute("unit")
    local header = self:GetParent()
    local petButton = self:GetFrameRef("petButton")

    -- print(self:GetName(), unit, petButton)

    if petButton and header:GetAttribute("showPartyPets") then
        local petUnit
        if unit == "player" then
            petUnit = "pet"
        else
            petUnit = string.gsub(unit, "party", "partypet")
        end
        petButton:SetAttribute("unit", petUnit)
        RegisterUnitWatch(petButton)
    end

    header:CallMethod("UpdateButtonUnits", self:GetName(), unit)
]])

header:SetAttribute("point", "TOP")
header:SetAttribute("xOffset", 0)
header:SetAttribute("yOffset", -1)
header:SetAttribute("maxColumns", 1)
header:SetAttribute("unitsPerColumn", 5)
header:SetAttribute("showPlayer", true)
header:SetAttribute("showParty", true)

--! to make needButtons == 5 cheat configureChildren in SecureGroupHeaders.lua
header:SetAttribute("startingIndex", -4)
header:Show()
header:SetAttribute("startingIndex", 1)

-- init pet buttons
for i, playerButton in ipairs({header:GetChildren()}) do
    local petButton = CreateFrame("Button", playerButton:GetName().."Pet", playerButton, "CellUnitButtonTemplate")
    petButton:SetIgnoreParentAlpha(true)
    
    playerButton.petButton = petButton
    SecureHandlerSetFrameRef(playerButton, "petButton", petButton)
    
    -- for IterateAllUnitButtons
    Cell.unitButtons.party["player"..i] = playerButton
    Cell.unitButtons.party["pet"..i] = petButton

    -- OmniCD
    _G["CellPartyFrameMember"..i] = playerButton
    -- playerButton.unitid = playerUnit
end

local init
local function PartyFrame_UpdateLayout(layout, which)
    -- if layout ~= Cell.vars.currentLayout then return end
    if Cell.vars.groupType ~= "party" and init then return end
    init = true
    layout = CellLayoutAutoSwitchTable[Cell.vars.playerSpecRole]["party"]
    layout = CellDB["layouts"][layout]

    -- anchor
    if not which or which == "spacing" or which == "orientation" or which == "anchor" then
        local point, playerAnchorPoint, petAnchorPoint, playerSpacing, petSpacing, headerPoint
        if layout["orientation"] == "vertical" then
            if layout["anchor"] == "BOTTOMLEFT" then
                point, playerAnchorPoint, petAnchorPoint = "BOTTOMLEFT", "TOPLEFT", "BOTTOMRIGHT"
                headerPoint = "BOTTOM"
                playerSpacing = layout["spacingY"]
                petSpacing = layout["spacingX"]
            elseif layout["anchor"] == "BOTTOMRIGHT" then
                point, playerAnchorPoint, petAnchorPoint = "BOTTOMRIGHT", "TOPRIGHT", "BOTTOMLEFT"
                headerPoint = "BOTTOM"
                playerSpacing = layout["spacingY"]
                petSpacing = -layout["spacingX"]
            elseif layout["anchor"] == "TOPLEFT" then
                point, playerAnchorPoint, petAnchorPoint = "TOPLEFT", "BOTTOMLEFT", "TOPRIGHT"
                headerPoint = "TOP"
                playerSpacing = -layout["spacingY"]
                petSpacing = layout["spacingX"]
            elseif layout["anchor"] == "TOPRIGHT" then
                point, playerAnchorPoint, petAnchorPoint = "TOPRIGHT", "BOTTOMRIGHT", "TOPLEFT"
                headerPoint = "TOP"
                playerSpacing = -layout["spacingY"]
                petSpacing = -layout["spacingX"]
            end

            header:SetAttribute("xOffset", 0)
            header:SetAttribute("yOffset", playerSpacing)
        else
            -- anchor
            if layout["anchor"] == "BOTTOMLEFT" then
                point, playerAnchorPoint, petAnchorPoint = "BOTTOMLEFT", "BOTTOMRIGHT", "TOPLEFT"
                headerPoint = "LEFT"
                playerSpacing = layout["spacingX"]
                petSpacing = layout["spacingY"]
            elseif layout["anchor"] == "BOTTOMRIGHT" then
                point, playerAnchorPoint, petAnchorPoint = "BOTTOMRIGHT", "BOTTOMLEFT", "TOPRIGHT"
                headerPoint = "RIGHT"
                playerSpacing = -layout["spacingX"]
                petSpacing = layout["spacingY"]
            elseif layout["anchor"] == "TOPLEFT" then
                point, playerAnchorPoint, petAnchorPoint = "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT"
                headerPoint = "LEFT"
                playerSpacing = layout["spacingX"]
                petSpacing = -layout["spacingY"]
            elseif layout["anchor"] == "TOPRIGHT" then
                point, playerAnchorPoint, petAnchorPoint = "TOPRIGHT", "TOPLEFT", "BOTTOMRIGHT"
                headerPoint = "RIGHT"
                playerSpacing = -layout["spacingX"]
                petSpacing = -layout["spacingY"]
            end

            header:SetAttribute("xOffset", playerSpacing)
            header:SetAttribute("yOffset", 0)
        end

        header:ClearAllPoints()
        header:SetPoint(point)
        header:SetAttribute("point", headerPoint)

        --! force update unitbutton's point
        for j = 1, 5 do
            header[j]:ClearAllPoints()
            -- update petButton's point
            header[j].petButton:ClearAllPoints()
            if layout["orientation"] == "vertical" then
                header[j].petButton:SetPoint(point, header[j], petAnchorPoint, petSpacing, 0)
            else
                header[j].petButton:SetPoint(point, header[j], petAnchorPoint, 0, petSpacing)
            end
        end
        header:SetAttribute("unitsPerColumn", 5)
    end

    if not which or which == "size" or which == "petSize" or which == "power" or which == "barOrientation" then
        for i, playerButton in ipairs({header:GetChildren()}) do
            local petButton = playerButton.petButton

            if not which or which == "size" then
                local width, height = unpack(layout["size"])
                P:Size(playerButton, width, height)
                header:SetAttribute("buttonWidth", P:Scale(width))
                header:SetAttribute("buttonHeight", P:Scale(height))
                P:Size(petButton, width, height)
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
        end
    end

    if not which or which == "pet" then
        header:SetAttribute("showPartyPets", layout["pet"][1])
        if layout["pet"][1] then
            for i, playerButton in ipairs({header:GetChildren()}) do
                RegisterUnitWatch(playerButton.petButton)
            end
        else
            for i, playerButton in ipairs({header:GetChildren()}) do
                UnregisterUnitWatch(playerButton.petButton)
                playerButton.petButton:Hide()
            end
        end
    end
end
Cell:RegisterCallback("UpdateLayout", "PartyFrame_UpdateLayout", PartyFrame_UpdateLayout)

local function PartyFrame_UpdateVisibility(which)
    if not which or which == "party" then
        if CellDB["general"]["showParty"] then
            RegisterAttributeDriver(partyFrame, "state-visibility", "[group:raid] hide; [group:party] show; hide")
        else
            UnregisterAttributeDriver(partyFrame, "state-visibility")
            partyFrame:Hide()
        end
    end
end
Cell:RegisterCallback("UpdateVisibility", "PartyFrame_UpdateVisibility", PartyFrame_UpdateVisibility)

local function PartyFrame_UpdateSortMethod()
    if CellDB["general"]["sortPartyByRole"] then
        header:SetAttribute("sortMethod", "NAME")
        header:SetAttribute("groupingOrder", "TANK,HEALER,DAMAGER,NONE")
        header:SetAttribute("groupBy", "ASSIGNEDROLE")
    else
        header:SetAttribute("sortMethod", "INDEX")
        header:SetAttribute("groupingOrder", "")
        header:SetAttribute("groupBy", nil)
    end
end
Cell:RegisterCallback("UpdateSortMethod", "PartyFrame_UpdateSortMethod", PartyFrame_UpdateSortMethod)