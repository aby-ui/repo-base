local LocalDatabase, GlobalDatabase, SavedVars = unpack(select(2, ...))

--<<IMPORTANT STUFF>>-------------------------------------------------------------------------------<<>>

    local Modified_Plates       = {}                        -- All edited name plates (used for the config function)
    local Visible_Plates        = {}                        -- All visible name plates, and their data
    local CachedMobs            = {}                        -- Holds quest data. One entry per mob(by name)

    local Height                = 32                        -- Height of the quest indicator (depends on the dimensions of the texture, in this case 2hx1w)
    local Width                 = 16                        -- Width of the quest indicator

    local GetNamePlateForUnit   = C_NamePlate.GetNamePlateForUnit
    local WorldFrame            = WorldFrame
    local Tooltip               = CreateFrame("GameTooltip", "KibQuestTooltip", nil, "GameTooltipTemplate")
    local inInstance

--<<CREATE QUEST ICON>>-----------------------------------------------------------------------------<<>>

    local function CreateQuestIcon(plateFrame)  
        plateFrame.Quest_Icon = CreateFrame("Frame", nil, plateFrame) plateFrame.Quest_Icon:Show()
        plateFrame.Quest_Icon:SetSize(Width * SavedVars.Scale, Height * SavedVars.Scale)
        plateFrame.Quest_Icon:SetIgnoreParentAlpha(true)
        plateFrame.Quest_Icon:SetPoint("BOTTOM", plateFrame, "TOP", SavedVars.IconXOffset, SavedVars.IconYOffset)   

        plateFrame.Quest_IconTexture = plateFrame.Quest_Icon:CreateTexture(nil, "OVERLAY")                                   
        plateFrame.Quest_IconTexture:SetTexture("Interface\\AddOns\\Kib_QuestMobs\\media\\questicon_" .. SavedVars.TextureVariant)
        plateFrame.Quest_IconTexture:SetAllPoints()

        plateFrame.Quest_TextFrame = CreateFrame("frame", nil, plateFrame.Quest_Icon)
        plateFrame.Quest_TextFrame:SetPoint("TOPLEFT", plateFrame, "BOTTOMLEFT", SavedVars.TasksXOffset, SavedVars.TasksYOffset + -15)
        plateFrame.Quest_TextFrame:Hide()

        plateFrame.Quest_Icon:SetScript("OnEnter", function() if SavedVars.ShowQuestTask and SavedVars.ShowQuestTaskOnMouseOver then plateFrame.Quest_TextFrame:Show() end end)
        plateFrame.Quest_Icon:SetScript("OnLeave", function() if SavedVars.ShowQuestTask and SavedVars.ShowQuestTaskOnMouseOver then plateFrame.Quest_TextFrame:Hide() end end)

        plateFrame.Quest_TextLines = {}

        Modified_Plates[#Modified_Plates + 1] = plateFrame
    end

--<<CREATE QUEST TEXT LINE>>------------------------------------------------------------------------<<>>

    local function CreateQuestTextLine(plateFrame, LineNum)    
        local Quest_TextLine = plateFrame.Quest_TextFrame:CreateFontString(nil, "OVERLAY", "GameTooltipTextSmall")
        Quest_TextLine:SetFont(GlobalDatabase.Font, SavedVars.TextSize)
        Quest_TextLine:SetJustifyH("Left")
        Quest_TextLine:SetPoint("TOPLEFT", plateFrame.Quest_TextFrame, "TOPLEFT", 0, SavedVars.TextSize * -(LineNum - 1))
        Quest_TextLine:SetPoint("BOTTOMRIGHT", plateFrame.Quest_TextFrame, "TOPRIGHT", 0, SavedVars.TextSize * -LineNum)
        Quest_TextLine:Hide()

        plateFrame.Quest_TextLines[LineNum] = Quest_TextLine
    end

--<<HANDLE QUEST DATA>>-----------------------------------------------------------------------------<<>>

    local function HandleQuestData(plateData)                                                   --GlobalDatabase.EventBucket_AddLine("Kib_QuestMobs", "Plate Updated: " .. plateData.unitName)
        local plateFrame, QuestData = plateData.unitFrame, CachedMobs[plateData.unitName]

        if QuestData.QuestType > 0 then
            if not plateFrame.Quest_Icon then CreateQuestIcon(plateFrame) end 

            --SET QUEST ICON COLOUR
            local Colour = (QuestData.QuestType == 1 and SavedVars.NormalQuestcolor) or (QuestData.QuestType == 2 and SavedVars.GroupQuestcolor) or SavedVars.AreaQuestcolor
            plateFrame.Quest_IconTexture:SetVertexColor(Colour.r, Colour.g, Colour.b, SavedVars.Alpha)

            --SET QUEST DESCRIPTIONS
            local NumTasks = #QuestData.QuestTasks

            if SavedVars.ShowQuestTask and NumTasks > 0 then
                for i = 1, #plateFrame.Quest_TextLines do plateFrame.Quest_TextLines[i]:Hide() end
            
                for i = 1, NumTasks do
                    if not plateFrame.Quest_TextLines[i] then CreateQuestTextLine(plateFrame, i) end
                    plateFrame.Quest_TextLines[i]:SetText(QuestData.QuestTasks[i])
                    plateFrame.Quest_TextLines[i]:Show()
                end

                plateFrame.Quest_TextFrame:SetPoint("BOTTOMRIGHT", plateFrame, "BOTTOMRIGHT", SavedVars.TasksXOffset, SavedVars.TasksYOffset + (-15 - (SavedVars.TextSize * NumTasks)))
                if not SavedVars.ShowQuestTaskOnMouseOver then plateFrame.Quest_TextFrame:Show() else plateFrame.Quest_TextFrame:Hide() end
            else
                plateFrame.Quest_TextFrame:Hide()
            end

            plateFrame.Quest_Icon:Show()
        else
            if plateFrame.Quest_Icon then plateFrame.Quest_Icon:Hide() end
        end

    end

--<<SCAN QUEST DATA>>-------------------------------------------------------------------------------<<>>
    local IgnoredQuests = { [C_TaskQuest.GetQuestInfoByQuestID(56064)] = true, [C_TaskQuest.GetQuestInfoByQuestID(56308)] = true  } --突袭黑暗帝国
    local ObjectiveLines = {}
    local function ScanPlate(plateData)                                                         --GlobalDatabase.EventBucket_AddLine("Kib_QuestMobs", "Plate Scanned and Cached: " .. plateData.unitName)
        local PlayerQuest, GroupQuest, AreaQuest, QuestTasks = nil, nil, nil, _empty_table --{}

        Tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
        Tooltip:SetHyperlink("unit:" .. plateData.unitGUID)

        wipe(ObjectiveLines)
        for i = 1, Tooltip:NumLines() do
            local texture = _G["KibQuestTooltipTexture" .. i]
            if not texture or not texture:IsShown() then break end
            if texture:GetTexture() == 3083385 then
                local anchor = select(2, texture:GetPoint())
                local line = tonumber(anchor:GetName():sub(#"KibQuestTooltipTextLeft" + 1))
                --一个人的时候是 <任务>\n - 进度，组队的时候是 <任务>\n人名\n-进度

                if GetNumGroupMembers() == 0 then
                    local quest = _G["KibQuestTooltipTextLeft" .. (line-1)]
                    quest = quest and quest:GetText()
                    if not IgnoredQuests[quest] then
                        ObjectiveLines[line] = true
                    end
                    -- 不需要记录false
                else
                    if ObjectiveLines[line - 2] == true then
                        ObjectiveLines[line] = true
                    elseif ObjectiveLines[line - 2] == false then
                        ObjectiveLines[line] = false
                    else
                        local quest = _G["KibQuestTooltipTextLeft" .. (line-2)]
                        quest = quest and quest:GetText()
                        if IgnoredQuests[quest] then
                            ObjectiveLines[line] = false
                        else
                            ObjectiveLines[line] = true
                        end
                    end
                end
            end
        end

        for i = 3, Tooltip:NumLines() do
            local line = _G["KibQuestTooltipTextLeft" .. i]
            local text = line:GetText()
            local text_r, text_g, text_b = line:GetTextColor()
            if not ObjectiveLines[i] and ObjectiveLines[i+1] then
                if text == UnitName("player") or GetNumGroupMembers() == 0 then
                    PlayerQuest = true
                    break -- not support QuestTasks
                else
                    GroupQuest = true
                end
                --[[
                QuestTasks[#QuestTasks + 1] = text
                while ObjectiveLines[i+1] do
                    local line = _G["KibQuestTooltipTextLeft" .. (i+1)]
                    local text = line:GetText()
                    QuestTasks[#QuestTasks + 1] = " - " .. text
                    i = i + 1
                end
                --]]
            end
            --[[
            if text_b == 0 and text_r > 0.99 and text_g > 0.82 then 
                AreaQuest = true
            else
                local Unit_Name, Progress = string.match(text, "^ ([^ ]-) ?%- (.+)$")
                if Progress then 
                    AreaQuest = nil

                    if Unit_Name then
                        local current, goal = string.match(Progress, "(%d+)/(%d+)")

                        if (current and goal) and (current ~= goal) then 
                            if (Unit_Name == "" or Unit_Name == GlobalDatabase.Player_Name) then 
                                PlayerQuest = true 
                                QuestTasks[#QuestTasks + 1] = Progress
                            else
                                GroupQuest = true
                            end
                        end
                    end
                end
            end
            --]]
        end

        local QuestType = (PlayerQuest and 1) or (GroupQuest and 2) or (AreaQuest and 3) or 0
        CachedMobs[plateData.unitName] = {QuestType = QuestType, QuestTasks = QuestTasks}
    end

    local function ScanAllPlates()                                                              --GlobalDatabase.EventBucket_AddLine("Kib_QuestMobs", "All Plates Scanned and Cached")
        for _, plateData in pairs(Visible_Plates) do
            if not CachedMobs[plateData.unitName] then ScanPlate(plateData) end
            HandleQuestData(plateData)
        end
    end

--<<HANDLE EVENTS>>---------------------------------------------------------------------------------<<>>
        
    function LocalDatabase.UNIT_QUEST_LOG_CHANGED() wipe(CachedMobs) ScanAllPlates() end

    function LocalDatabase.PLAYER_ENTERING_WORLD() inInstance = IsInInstance() end

    function LocalDatabase.UNIT_THREAT_LIST_UPDATE(UnitID)
        if not SavedVars.DisableInCombat then return end
        
        local UnitPlate = Visible_Plates[UnitID] 
        if not UnitPlate then return end

        if UnitThreatSituation("player", UnitID) then 
            if (UnitPlate.unitFrame.Quest_Icon and UnitPlate.unitFrame.Quest_Icon:IsShown()) then UnitPlate.unitFrame.Quest_Icon:Hide() end
        else
            ScanPlate(Visible_Plates[UnitID])
            HandleQuestData(Visible_Plates[UnitID])
        end
    end
    
    function LocalDatabase.NAME_PLATE_UNIT_REMOVED(plateID)                                     --GlobalDatabase.EventBucket_AddLine("Kib_QuestMobs", "Plate Removed: " .. UnitName(plateID))
        if Visible_Plates[plateID] then Visible_Plates[plateID] = nil end
    end

    function LocalDatabase.NAME_PLATE_UNIT_ADDED(plateID)                                       --GlobalDatabase.EventBucket_AddLine("Kib_QuestMobs", "Plate Found: " .. UnitName(plateID))
        local plateFrame = GetNamePlateForUnit(plateID)

        local unitName = UnitName(plateID) 
        Visible_Plates[plateID] = {unitFrame = plateFrame, unitName = unitName, unitGUID = UnitGUID(plateID), plateID = plateID}

        if (SavedVars.DisableInInstance and inInstance) or (SavedVars.DisableInCombat and UnitThreatSituation("player", plateID)) or not UnitCanAttack(plateID, "player") then 
            if plateFrame.Quest_Icon then plateFrame.Quest_Icon:Hide() end return 
        end

        if not CachedMobs[unitName] then ScanPlate(Visible_Plates[plateID]) end
        HandleQuestData(Visible_Plates[plateID])
    end

--<<CONFIG RESET FUNCTION>>-------------------------------------------------------------------------<<>>

    function LocalDatabase.ResetAllElements()
        for _, plateFrame in pairs(Modified_Plates) do
            plateFrame.Quest_Icon:SetPoint("BOTTOM", plateFrame, "TOP", SavedVars.IconXOffset, SavedVars.IconYOffset)
            plateFrame.Quest_Icon:SetSize(Width * SavedVars.Scale, Height * SavedVars.Scale)
            plateFrame.Quest_IconTexture:SetTexture("Interface\\AddOns\\Kib_QuestMobs\\media\\questicon_" .. SavedVars.TextureVariant)
            plateFrame.Quest_TextFrame:SetPoint("TOPLEFT", plateFrame, "BOTTOMLEFT", SavedVars.TasksXOffset, SavedVars.TasksYOffset + -15)

            for i = 1, #plateFrame.Quest_TextLines do
                plateFrame.Quest_TextLines[i]:SetFont(GlobalDatabase.Font, SavedVars.TextSize)

                plateFrame.Quest_TextLines[i]:SetPoint("TOPLEFT", plateFrame.Quest_TextFrame, "TOPLEFT", 0, SavedVars.TextSize * -(i - 1))
                plateFrame.Quest_TextLines[i]:SetPoint("BOTTOMRIGHT", plateFrame.Quest_TextFrame, "TOPRIGHT", 0, SavedVars.TextSize * -i)
            end
        end
        ScanAllPlates()
    end

----------------------------------------------------------------------------------------------------<<END>>