local _, Cell = ...
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local raidFrame = CreateFrame("Frame", "CellRaidFrame", Cell.frames.mainFrame, "SecureHandlerAttributeTemplate")
Cell.frames.raidFrame = raidFrame
raidFrame:SetAllPoints(Cell.frames.mainFrame)

local npcFrameAnchor = CreateFrame("Frame", "CellNPCFrameAnchor", raidFrame, "SecureFrameTemplate")
npcFrameAnchor:Hide()
raidFrame:SetFrameRef("npcAnchor", npcFrameAnchor)

raidFrame:SetAttribute("_onattributechanged", [[
    if name ~= "visibility" then
        return
    end

    local maxGroup
    for i = 1, 8 do
        if self:GetFrameRef("visibilityhelper"..i):IsVisible() then
            maxGroup = i
        end
    end

    if not maxGroup then return end -- NOTE: empty subgroup will cause maxGroup == nil
    
    local header = self:GetFrameRef("subgroup"..maxGroup)
    local npcFrameAnchor = self:GetFrameRef("npcAnchor")
    local spacing = self:GetAttribute("spacing") or 0
    local orientation = self:GetAttribute("orientation") or "vertical"
    local anchor = self:GetAttribute("anchor") or "TOPLEFT"

    npcFrameAnchor:ClearAllPoints()
    local point, anchorPoint
    if orientation == "vertical" then
        if anchor == "BOTTOMLEFT" then
            point, anchorPoint = "BOTTOMLEFT", "BOTTOMRIGHT"
        elseif anchor == "BOTTOMRIGHT" then
            point, anchorPoint = "BOTTOMRIGHT", "BOTTOMLEFT"
        elseif anchor == "TOPLEFT" then
            point, anchorPoint = "TOPLEFT", "TOPRIGHT"
        elseif anchor == "TOPRIGHT" then
            point, anchorPoint = "TOPRIGHT", "TOPLEFT"
        end

        npcFrameAnchor:SetPoint(point, header, anchorPoint, spacing, 0)
    else
        if anchor == "BOTTOMLEFT" then
            point, anchorPoint = "BOTTOMLEFT", "TOPLEFT"
        elseif anchor == "BOTTOMRIGHT" then
            point, anchorPoint = "BOTTOMRIGHT", "TOPRIGHT"
        elseif anchor == "TOPLEFT" then
            point, anchorPoint = "TOPLEFT", "BOTTOMLEFT"
        elseif anchor == "TOPRIGHT" then
            point, anchorPoint = "TOPRIGHT", "BOTTOMRIGHT"
        end

        npcFrameAnchor:SetPoint(point, header, anchorPoint, 0, spacing)
    end
]])

--[[ Interface\FrameXML\SecureGroupHeaders.lua
List of the various configuration attributes
======================================================
showRaid = [BOOLEAN] -- true if the header should be shown while in a raid
showParty = [BOOLEAN] -- true if the header should be shown while in a party and not in a raid
showPlayer = [BOOLEAN] -- true if the header should show the player when not in a raid
showSolo = [BOOLEAN] -- true if the header should be shown while not in a group (implies showPlayer)
nameList = [STRING] -- a comma separated list of player names (not used if 'groupFilter' is set)
groupFilter = [1-8, STRING] -- a comma seperated list of raid group numbers and/or uppercase class names and/or uppercase roles
roleFilter = [STRING] -- a comma seperated list of MT/MA/Tank/Healer/DPS role strings
strictFiltering = [BOOLEAN] 
-- if true, then 
---- if only groupFilter is specified then characters must match both a group and a class from the groupFilter list
---- if only roleFilter is specified then characters must match at least one of the specified roles
---- if both groupFilter and roleFilters are specified then characters must match a group and a class from the groupFilter list and a role from the roleFilter list
point = [STRING] -- a valid XML anchoring point (Default: "TOP")
xOffset = [NUMBER] -- the x-Offset to use when anchoring the unit buttons (Default: 0)
yOffset = [NUMBER] -- the y-Offset to use when anchoring the unit buttons (Default: 0)
sortMethod = ["INDEX", "NAME", "NAMELIST"] -- defines how the group is sorted (Default: "INDEX")
sortDir = ["ASC", "DESC"] -- defines the sort order (Default: "ASC")
template = [STRING] -- the XML template to use for the unit buttons
templateType = [STRING] - specifies the frame type of the managed subframes (Default: "Button")
groupBy = [nil, "GROUP", "CLASS", "ROLE", "ASSIGNEDROLE"] - specifies a "grouping" type to apply before regular sorting (Default: nil)
groupingOrder = [STRING] - specifies the order of the groupings (ie. "1,2,3,4,5,6,7,8")
maxColumns = [NUMBER] - maximum number of columns the header will create (Default: 1)
unitsPerColumn = [NUMBER or nil] - maximum units that will be displayed in a singe column, nil is infinite (Default: nil)
startingIndex = [NUMBER] - the index in the final sorted unit list at which to start displaying units (Default: 1)
columnSpacing = [NUMBER] - the amount of space between the rows/columns (Default: 0)
columnAnchorPoint = [STRING] - the anchor point of each new column (ie. use LEFT for the columns to grow to the right)
--]]
local groupHeaders = {}
local function CreateGroupHeader(group)
    local headerName = "CellRaidFrameHeader"..group
    local header = CreateFrame("Frame", headerName, raidFrame, "SecureGroupHeaderTemplate")
    groupHeaders[group] = header
    Cell.unitButtons.raid[headerName] = header

    header:SetAttribute("initialConfigFunction", [[
        RegisterUnitWatch(self)

        local header = self:GetParent()
        self:SetWidth(header:GetAttribute("buttonWidth") or 66)
        self:SetHeight(header:GetAttribute("buttonHeight") or 46)
    ]])

    header:SetAttribute("template", "CellUnitButtonTemplate")
    header:SetAttribute("columnAnchorPoint", "LEFT")
    header:SetAttribute("point", "TOP")
    header:SetAttribute("groupFilter", group)
    -- header:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
    -- header:SetAttribute("groupBy", "ASSIGNEDROLE")
    -- header:SetAttribute("groupingOrder", "TANK,HEALER,DAMAGER,NONE")
    -- header:SetAttribute("maxColumns", 8)
    header:SetAttribute("xOffset", 0)
    header:SetAttribute("yOffset", -1)
    header:SetAttribute("unitsPerColumn", 5)
    header:SetAttribute("columnSpacing", 1)
    header:SetAttribute("maxColumns", 1)
    -- header:SetAttribute("startingIndex", 1)
    header:SetAttribute("showRaid", true)

    --[[ Interface\FrameXML\SecureGroupHeaders.lua line 150
        local loopStart = startingIndex;
        local loopFinish = min((startingIndex - 1) + unitsPerColumn * numColumns, unitCount)
        -- ensure there are enough buttons
        numDisplayed = loopFinish - (loopStart - 1)
        local needButtons = max(1, numDisplayed); --! to make needButtons == 5
    ]]
    
    --! to make needButtons == 5 cheat configureChildren in SecureGroupHeaders.lua
    header:SetAttribute("startingIndex", -4)
    header:Show()
    header:SetAttribute("startingIndex", 1)

    -- for npcFrame's point
    raidFrame:SetFrameRef("subgroup"..group, header)
    
    local helper = CreateFrame("Frame", nil, header[1], "SecureHandlerShowHideTemplate")
    helper:SetFrameRef("raidframe", raidFrame)
    raidFrame:SetFrameRef("visibilityhelper"..group, helper)
    helper:SetAttribute("_onshow", [[ self:GetFrameRef("raidframe"):SetAttribute("visibility", 1) ]])
    helper:SetAttribute("_onhide", [[ self:GetFrameRef("raidframe"):SetAttribute("visibility", 0) ]])
end

for i = 1, 8 do
    CreateGroupHeader(i)
end

-- arena pet
local arenaPetButtons = {}
for i = 1, (Cell.isRetail and 3 or 5) do
    arenaPetButtons[i] = CreateFrame("Button", "CellArenaPet"..i, raidFrame, "CellUnitButtonTemplate")
    arenaPetButtons[i]:SetAttribute("unit", "raidpet"..i)

    Cell.unitButtons.arena["raidpet"..i] = arenaPetButtons[i]
end

local init
local function RaidFrame_UpdateLayout(layout, which)
    -- if layout ~= Cell.vars.currentLayout then return end
    if Cell.vars.groupType ~= "raid" and init then return end
    init = true

    if Cell.vars.inBattleground == 5 then
        layout = CellLayoutAutoSwitchTable[Cell.vars.playerSpecRole]["arena"]
    elseif Cell.vars.inBattleground == 15 or Cell.vars.inBattleground == 40 then
        layout = CellLayoutAutoSwitchTable[Cell.vars.playerSpecRole]["battleground"..Cell.vars.inBattleground]
    elseif Cell.vars.inMythic then -- retail
        layout = CellLayoutAutoSwitchTable[Cell.vars.playerSpecRole]["raid_mythic"]
    elseif Cell.vars.inInstance then -- retail
        layout = CellLayoutAutoSwitchTable[Cell.vars.playerSpecRole]["raid_instance"]
    elseif Cell.vars.raidType then -- wrath
        layout = CellLayoutAutoSwitchTable[Cell.vars.playerSpecRole][Cell.vars.raidType]
    else
        layout = CellLayoutAutoSwitchTable[Cell.vars.playerSpecRole]["raid_outdoor"]
    end

    layout = CellDB["layouts"][layout]

    -- arena pets
    if Cell.vars.inBattleground == 5 and layout["pet"][1] then
        for i, arenaPet in ipairs(arenaPetButtons) do
            RegisterAttributeDriver(arenaPet, "state-visibility", "[@raidpet"..i..", exists] show; hide")
        end
    else
        for i, arenaPet in ipairs(arenaPetButtons) do
            UnregisterAttributeDriver(arenaPet, "state-visibility")
            arenaPet:Hide()
        end
    end

    local width, height = unpack(layout["size"])

    local shownGroups = {}
    for i, isShown in ipairs(layout["groupFilter"]) do
        if isShown then
            tinsert(shownGroups, i)
        end
    end

    if not which or which == "size" or which == "petSize" or which == "power" or which == "barOrientation" then
        for i, arenaPet in ipairs(arenaPetButtons) do
            if layout["pet"][4] then
                P:Size(arenaPet, layout["pet"][5][1], layout["pet"][5][2])
            else
                P:Size(arenaPet, width, height)
            end
            -- NOTE: SetOrientation BEFORE SetPowerSize
            arenaPet.func.SetOrientation(unpack(layout["barOrientation"]))
            arenaPet.func.SetPowerSize(layout["powerSize"])
        end
    end

    for i, group in ipairs(shownGroups) do
        local header = groupHeaders[group]

        if not which or which == "size" or which == "petSize" or which == "power" or which == "groupFilter" or which == "barOrientation" then
            for j, b in ipairs({header:GetChildren()}) do
                if not which or which == "size" or which == "groupFilter" then
                    P:Size(b, width, height)
                    b:ClearAllPoints()
                end
                -- NOTE: SetOrientation BEFORE SetPowerSize
                if not which or which == "barOrientation" then
                    b.func.SetOrientation(unpack(layout["barOrientation"]))
                end
                if not which or which == "power" or which == "groupFilter" or which == "barOrientation" then
                    b.func.SetPowerSize(layout["powerSize"])
                end
            end

            if not which or which == "size" or which == "groupFilter" then
                --! important new button size depend on buttonWidth & buttonHeight
                header:SetAttribute("buttonWidth", P:Scale(width))
                header:SetAttribute("buttonHeight", P:Scale(height))

                -- 确保按钮在“一定程度上”对齐
                header:SetAttribute("minWidth", P:Scale(width))
                header:SetAttribute("minHeight", P:Scale(height))

                P:Size(npcFrameAnchor, width, height)
            end
        end

        if not which or which == "spacing" or which == "orientation" or which == "anchor" or which == "rows_columns" or which == "groupSpacing" or which == "groupFilter" then
            header:ClearAllPoints()
            -- anchor
            local point, anchorPoint, groupAnchorPoint, unitSpacing, groupSpacing, verticalSpacing, horizontalSpacing, headerPoint, headerColumnAnchorPoint
            if layout["orientation"] == "vertical" then
                if layout["anchor"] == "BOTTOMLEFT" then
                    point, anchorPoint, groupAnchorPoint = "BOTTOMLEFT", "TOPLEFT", "BOTTOMRIGHT"
                    headerPoint, headerColumnAnchorPoint = "BOTTOM", "LEFT"
                    unitSpacing = layout["spacingY"]
                    groupSpacing = layout["spacingX"]
                    verticalSpacing = layout["spacingY"]+layout["groupSpacing"]
                elseif layout["anchor"] == "BOTTOMRIGHT" then
                    point, anchorPoint, groupAnchorPoint = "BOTTOMRIGHT", "TOPRIGHT", "BOTTOMLEFT"
                    headerPoint, headerColumnAnchorPoint = "BOTTOM", "RIGHT"
                    unitSpacing = layout["spacingY"]
                    groupSpacing = -layout["spacingX"]
                    verticalSpacing = layout["spacingY"]+layout["groupSpacing"]
                elseif layout["anchor"] == "TOPLEFT" then
                    point, anchorPoint, groupAnchorPoint = "TOPLEFT", "BOTTOMLEFT", "TOPRIGHT"
                    headerPoint, headerColumnAnchorPoint = "TOP", "LEFT"
                    unitSpacing = -layout["spacingY"]
                    groupSpacing = layout["spacingX"]
                    verticalSpacing = -layout["spacingY"]-layout["groupSpacing"]
                elseif layout["anchor"] == "TOPRIGHT" then
                    point, anchorPoint, groupAnchorPoint = "TOPRIGHT", "BOTTOMRIGHT", "TOPLEFT"
                    headerPoint, headerColumnAnchorPoint = "TOP", "RIGHT"
                    unitSpacing = -layout["spacingY"]
                    groupSpacing = -layout["spacingX"]
                    verticalSpacing = -layout["spacingY"]-layout["groupSpacing"]
                end

                header:SetAttribute("columnAnchorPoint", headerColumnAnchorPoint)
                header:SetAttribute("point", headerPoint)
                header:SetAttribute("xOffset", 0)
                header:SetAttribute("yOffset", unitSpacing)

                --! force update unitbutton's point
                for j = 1, 5 do
                    header[j]:ClearAllPoints()
                end
                header:SetAttribute("unitsPerColumn", 5)
                
                if i == 1 then
                    header:SetPoint(point)
                    -- arena pets
                    for k in ipairs(arenaPetButtons) do
                        arenaPetButtons[k]:ClearAllPoints()
                        if k == 1 then
                            arenaPetButtons[k]:SetPoint(point, npcFrameAnchor)
                        else
                            arenaPetButtons[k]:SetPoint(point, arenaPetButtons[k-1], anchorPoint, 0, unitSpacing)
                        end
                    end
                else
                    if i / layout["columns"] > 1 then -- not the first row
                        header:SetPoint(point, groupHeaders[shownGroups[i-layout["columns"]]], anchorPoint, 0, verticalSpacing)
                    else
                        header:SetPoint(point, groupHeaders[shownGroups[i-1]], groupAnchorPoint, groupSpacing, 0)
                    end
                end
            else
                if layout["anchor"] == "BOTTOMLEFT" then
                    point, anchorPoint, groupAnchorPoint = "BOTTOMLEFT", "BOTTOMRIGHT", "TOPLEFT"
                    headerPoint, headerColumnAnchorPoint = "LEFT", "BOTTOM"
                    unitSpacing = layout["spacingX"]
                    groupSpacing = layout["spacingY"]
                    horizontalSpacing = layout["spacingX"]+layout["groupSpacing"]
                elseif layout["anchor"] == "BOTTOMRIGHT" then
                    point, anchorPoint, groupAnchorPoint = "BOTTOMRIGHT", "BOTTOMLEFT", "TOPRIGHT"
                    headerPoint, headerColumnAnchorPoint = "RIGHT", "BOTTOM"
                    unitSpacing = -layout["spacingX"]
                    groupSpacing = layout["spacingY"]
                    horizontalSpacing = -layout["spacingX"]-layout["groupSpacing"]
                elseif layout["anchor"] == "TOPLEFT" then
                    point, anchorPoint, groupAnchorPoint = "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT"
                    headerPoint, headerColumnAnchorPoint = "LEFT", "TOP"
                    unitSpacing = layout["spacingX"]
                    groupSpacing = -layout["spacingY"]
                    horizontalSpacing = layout["spacingX"]+layout["groupSpacing"]
                elseif layout["anchor"] == "TOPRIGHT" then
                    point, anchorPoint, groupAnchorPoint = "TOPRIGHT", "TOPLEFT", "BOTTOMRIGHT"
                    headerPoint, headerColumnAnchorPoint = "RIGHT", "TOP"
                    unitSpacing = -layout["spacingX"]
                    groupSpacing = -layout["spacingY"]
                    horizontalSpacing = -layout["spacingX"]-layout["groupSpacing"]
                end

                header:SetAttribute("columnAnchorPoint", headerColumnAnchorPoint)
                header:SetAttribute("point", headerPoint)
                header:SetAttribute("xOffset", unitSpacing)
                header:SetAttribute("yOffset", 0)
               
                --! force update unitbutton's point
                for j = 1, 5 do
                    header[j]:ClearAllPoints()
                end
                header:SetAttribute("unitsPerColumn", 5)
               
                if i == 1 then
                    header:SetPoint(point)
                    -- arena pets
                    for k in ipairs(arenaPetButtons) do
                        arenaPetButtons[k]:ClearAllPoints()
                        if k == 1 then
                            arenaPetButtons[k]:SetPoint(point, npcFrameAnchor)
                        else
                            arenaPetButtons[k]:SetPoint(point, arenaPetButtons[k-1], anchorPoint, unitSpacing, 0)
                        end
                    end
                else
                    if i / layout["rows"] > 1 then -- not the first column
                        header:SetPoint(point, groupHeaders[shownGroups[i-layout["rows"]]], anchorPoint, horizontalSpacing, 0)
                    else
                        header:SetPoint(point, groupHeaders[shownGroups[i-1]], groupAnchorPoint, 0, groupSpacing)
                    end
                end
            end

            raidFrame:SetAttribute("spacing", groupSpacing)
            raidFrame:SetAttribute("orientation", layout["orientation"])
            raidFrame:SetAttribute("anchor", layout["anchor"])
            raidFrame:SetAttribute("visibility", 1) -- NOTE: trigger _onattributechanged to set npcFrameAnchor point!
        end

        -- REVIEW: fix name width
        if which == "groupFilter" then
            for j, b in ipairs({header:GetChildren()}) do
                b.widget.healthBar:GetScript("OnSizeChanged")(b.widget.healthBar)
            end
            for k, arenaPet in ipairs(arenaPetButtons) do
                arenaPet.widget.healthBar:GetScript("OnSizeChanged")(arenaPet.widget.healthBar)
            end
        end
    end

    -- show/hide groups
    if not which or which == "groupFilter" then
        for i = 1, 8 do
            if layout["groupFilter"][i] then
                groupHeaders[i]:Show()
            else
                groupHeaders[i]:Hide()
            end
        end
    end
end
Cell:RegisterCallback("UpdateLayout", "RaidFrame_UpdateLayout", RaidFrame_UpdateLayout)