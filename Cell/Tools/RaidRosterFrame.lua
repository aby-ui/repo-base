local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local raidRosterFrame = Cell:CreateFrame("CellRaidRosterFrame", Cell.frames.mainFrame, 405, 230)
Cell.frames.raidRosterFrame = raidRosterFrame
raidRosterFrame:SetFrameStrata("HIGH")

local assistantCB
local function CreateWidgets()
    assistantCB = Cell:CreateCheckButton(raidRosterFrame, "|TInterface\\GroupFrame\\UI-Group-AssistantIcon:16:16|t", function(checked)
        SetEveryoneIsAssistant(checked)
    end)
    assistantCB:SetPoint("BOTTOMRIGHT", -25, 5)

    local tips = Cell:CreateScrollTextFrame(raidRosterFrame, "|cffb7b7b7"..L["raidRosterTips"], 0.02, nil, 2)
    tips:SetPoint("BOTTOMLEFT", raidRosterFrame, 5, 2)
    tips:SetPoint("RIGHT", assistantCB, "LEFT", -5, 0)
end

-------------------------------------------------
-- sort TODO:
-------------------------------------------------
-- local sortText = Cell:CreateSeparator(L["Raid Sort"], raidRosterFrame, raidRosterFrame:GetWidth()-10)
-- sortText:SetPoint("TOPLEFT", 5, -5)

-- local function SetSubgroup(subgroup, index)

-- end

-- local members = {}
-- local function Sort(maxSubgroup)
--     for i = 1, GetNumGroupMembers() do
--         local name, _, subgroup, _, _, classFileName, _, _, _, _, _, combatRole = GetRaidRosterInfo(i)
--         if subgroup > maxSubgroup then break end

--     end
-- end

-------------------------------------------------
-- roster
-------------------------------------------------
local groups, changed = {}, {}
local movingGrid
local function CreateRaidRosterGrid(parent, index)
    local grid = CreateFrame("Button", parent:GetName().."Unit"..index, parent, "BackdropTemplate")
    P:Size(grid, 100, 17)
    Cell:StylizeFrame(grid, {0.1, 0.1, 0.1, 0.5})
    grid.color = {0.5, 0.5, 0.5}

    grid:SetFrameLevel(7)
    
    local roleIconBg = grid:CreateTexture(nil, "BORDER")
    roleIconBg:SetPoint("TOPLEFT", 2, -2)
    roleIconBg:SetSize(13, 13)
    roleIconBg:SetColorTexture(0, 0, 0, 1)

    local roleIcon = grid:CreateTexture(nil, "ARTWORK")
    roleIcon:SetPoint("TOPLEFT", roleIconBg, P:Scale(1), P:Scale(-1))
    roleIcon:SetPoint("BOTTOMRIGHT", roleIconBg, P:Scale(-1), P:Scale(1))
    roleIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    local nameText = grid:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    nameText:SetPoint("LEFT", roleIcon, "RIGHT", 2, 0)
    nameText:SetPoint("RIGHT", -2, 0)
    nameText:SetWordWrap(false)
    nameText:SetJustifyH("LEFT")

    -- click
    grid:RegisterForClicks("RightButtonDown")
    grid:SetScript("OnClick", function()
        if IsAltKeyDown() then
            UninviteUnit(grid.name)
        else
            if not UnitIsGroupLeader("player") then return end
            
            if UnitIsGroupLeader(grid.unit) then return end

            if UnitIsGroupAssistant(grid.unit) then
                DemoteAssistant(grid.unit)
            else
                PromoteToAssistant(grid.unit)
            end
        end
    end)

    -- drag
    grid:SetMovable(true)
    grid:RegisterForDrag("LeftButton")
    grid:SetScript("OnDragStart", function()
        grid:SetFrameLevel(9)
        grid:StartMoving()
        grid:SetUserPlaced(false)
        grid:SetBackdropBorderColor(unpack(grid.color))
        grid:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
        grid.isMoving = true
        movingGrid = grid
    end)
    grid:SetScript("OnDragStop", function()
        grid:SetFrameLevel(7)
        grid:StopMovingOrSizing()
        grid:ClearAllPoints()
        grid:SetPoint(unpack(grid.point1))
        grid:SetPoint(unpack(grid.point2))
        grid:SetBackdropBorderColor(0, 0, 0, 1)
        grid:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
        grid.isMoving = nil
    end)
    
    -- swap
    grid:SetScript("OnShow", function()
        grid:RegisterEvent("GLOBAL_MOUSE_UP")
    end)
    grid:SetScript("OnHide", function()
        grid:UnregisterEvent("GLOBAL_MOUSE_UP")
    end)
    grid:SetScript("OnEvent", function(self, event)
        if movingGrid and movingGrid ~= self and self:IsMouseOver() and not InCombatLockdown() then
            -- immediate mode
            if self.hasUnit then
                -- print("SWAP "..self:GetName().." WITH "..movingGrid:GetName())
                SwapRaidSubgroup(movingGrid.raidIndex, self.raidIndex)
            else
                SetRaidSubgroup(movingGrid.raidIndex, self.subgroup)
            end
            -- TODO: preset mode
            -- if self.hasUnit then
            --     self:SetText(movingGrid.name)
            --     self:SetTextColor(unpack(movingGrid.color))
            --     movingGrid:SetText(self.name)
            --     movingGrid:SetTextColor(unpack(self.color))
            -- end

            movingGrid = nil
        end
    end)

    -- onupdate
    grid:SetScript("OnUpdate", function()
        if not grid.isMoving then
            if grid:IsMouseOver() then
                grid:SetBackdropColor(grid.color[1], grid.color[2], grid.color[3], 0.2)
            else
                grid:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
            end
        end
    end)

    function grid:Set(name, color, role, isLeader, isAssistant)
        grid.color[1], grid.color[2], grid.color[3] = color[1], color[2], color[3]
        nameText:SetText(name)
        nameText:SetTextColor(unpack(color))
        
        roleIcon:Show()
        roleIconBg:Show()
        if role == "NONE" then
            roleIcon:SetTexture(134400)
        else
            roleIcon:SetTexture("Interface\\AddOns\\Cell\\Media\\Roles\\"..role)
        end

        if isLeader then
            roleIconBg:SetColorTexture(1, 0.84, 0, 1)
        elseif isAssistant then
            roleIconBg:SetColorTexture(0.7, 0.7, 0.7, 1)
        else
            roleIconBg:SetColorTexture(0, 0, 0, 1)
        end
    end

    function grid:Reset()
        grid.hasUnit = nil
        grid.raidIndex = nil
        grid.name = nil
        grid.color[1], grid.color[2], grid.color[3] = 0.5, 0.5, 0.5

        nameText:SetText("")
        nameText:SetTextColor(1, 1, 1)
        roleIconBg:SetColorTexture(0, 0, 0, 1)
        roleIconBg:Hide()
        roleIcon:Hide()

        grid:EnableMouse(false)

        -- reset click
        -- grid:SetAttribute("unit", nil)
        -- grid:SetAttribute("type1", nil)
    end

    function grid:SetInfo(name, classFileName, combatRole, raidIndex)
        if not name then
            -- unknown target, retry
            C_Timer.After(0.5, function()
                local name, _, subgroup, _, _, classFileName, _, _, _, _, _, combatRole = GetRaidRosterInfo(raidIndex)
                grid:SetInfo(name, classFileName, combatRole, raidIndex)
            end)
            return
        end
        
        if string.find(name, "-") then name = strsplit("-", name) end

        grid.hasUnit = true
        grid.raidIndex = raidIndex
        grid.unit = "raid"..raidIndex
        grid.name = name
        grid.role = combatRole
        grid.color[1], grid.color[2], grid.color[3] = F:GetClassColor(classFileName)

        grid:Set(name, grid.color, combatRole, UnitIsGroupLeader(grid.unit), UnitIsGroupAssistant(grid.unit))

        grid:EnableMouse(true)

        -- click
        -- grid:SetAttribute("unit", "raid"..raidIndex)
        -- grid:SetAttribute("type1", "target")
    end

    return grid
end

local function CreateRaidRosterGroup(parent, groupIndex)
    local group = CreateFrame("Frame", parent:GetName().."_Subgroup"..groupIndex, parent, "BackdropTemplate")
    P:Size(group, 95, 81)
    Cell:StylizeFrame(group, {0.1, 0.1, 0.1, 0.5})

    local headerText = group:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    headerText:SetPoint("BOTTOM", group, "TOP", 0, 1)
    headerText:SetText("|cFFEEC900"..GROUP.." "..groupIndex)

    for i = 1, 5 do
        group[i] = CreateRaidRosterGrid(group, i)
        group[i].point1 = {"TOPLEFT", 0, -(i-1)*16}
        group[i]:SetPoint(unpack(group[i].point1))
        group[i].point2 = {"TOPRIGHT", 0, -(i-1)*16}
        group[i]:SetPoint(unpack(group[i].point2))
        group[i].subgroup = groupIndex
    end

    group.numMembers = 0

    function group:Reset()
        group.numMembers = 0
        for i = 1, 5 do
            group[i]:Reset()
        end
    end

    function group:Insert(name, classFileName, combatRole, raidIndex)
        group.numMembers = group.numMembers + 1
        group[group.numMembers]:SetInfo(name, classFileName, combatRole, raidIndex)
    end

    return group
end

local function CreateRosterContainer()
    local rosterContainer = CreateFrame("Frame", "CellRaidRosterFrame_Container", raidRosterFrame)
    rosterContainer:SetPoint("TOPLEFT", 5, -5)
    rosterContainer:SetPoint("BOTTOMRIGHT", raidRosterFrame, "TOPRIGHT", -5, -207)

    for i = 1, 8 do
        groups[i] = CreateRaidRosterGroup(rosterContainer, i)
    
        if i % 4 == 1 then
            groups[i]:SetPoint("TOPLEFT", 0, -20-(math.modf(i/4)*(groups[i]:GetHeight()+20)))
        else
            groups[i]:SetPoint("TOPLEFT", groups[i-1], "TOPRIGHT", 5, 0)
        end
    end
end

-------------------------------------------------
-- functions
-------------------------------------------------
local function UpdateRoster()
    if movingGrid then
        movingGrid:GetScript("OnDragStop")()
    end

    for i = 1, 8 do
        groups[i]:Reset()
    end

    for i = 1, GetNumGroupMembers() do
        local name, _, subgroup, _, _, classFileName, _, _, _, _, _, combatRole = GetRaidRosterInfo(i)
        groups[subgroup]:Insert(name, classFileName, combatRole, i)
    end
end

local function CheckPermission()
    if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
        if raidRosterFrame.mask then raidRosterFrame.mask:Hide() end
    else
        Cell:CreateMask(raidRosterFrame, L["You don't have permission to do this"], {1, -1, -1, 1})
    end
end

raidRosterFrame:SetScript("OnEvent", function()
    UpdateRoster()
    CheckPermission()
    assistantCB:SetChecked(IsEveryoneAssistant())
end)

raidRosterFrame:SetScript("OnShow", function()
    raidRosterFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    UpdateRoster()
    CheckPermission()
    assistantCB:SetChecked(IsEveryoneAssistant())
end)
raidRosterFrame:SetScript("OnHide", function()
    raidRosterFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
end)

local function GroupTypeChanged(groupType)
    raidRosterFrame:Hide()
end
Cell:RegisterCallback("GroupTypeChanged", "RaidRosterFrame_GroupTypeChanged", GroupTypeChanged)

local function UpdateLayout(layout, which)
    layout = Cell.vars.currentLayoutTable
    if not which or which == "anchor" then
        raidRosterFrame:ClearAllPoints()
        raidRosterFrame:SetPoint(layout["anchor"], Cell.frames.mainFrame)
    end
end
Cell:RegisterCallback("UpdateLayout", "RaidRosterFrame_UpdateLayout", UpdateLayout)

local init
function F:ShowRaidRosterFrame()
    if not init then
        init = true
        raidRosterFrame:UpdatePixelPerfect()
        CreateWidgets()
        CreateRosterContainer()
    end

    if raidRosterFrame:IsShown() then
        raidRosterFrame:Hide()
    else
        raidRosterFrame:Show()
    end
end