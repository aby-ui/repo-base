local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local Serializer = LibStub:GetLibrary("LibSerialize")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local deflateConfig = {level = 9}

local isImport, imported = false, {}
local exportedAllBosses, exported = false, ""
local currentInstanceId, currentBossId, currentBossName
local ShowData

local importExportFrame, importBtn, title, instance, boss, whichBossesBtn, textArea

local function CreateDebuffsImportExportFrame()
    importExportFrame = CreateFrame("Frame", "CellOptionsFrame_RaidDebuffsImportExport", Cell.frames.raidDebuffsTab, "BackdropTemplate")
    importExportFrame:Hide()
    Cell:StylizeFrame(importExportFrame, nil, Cell:GetAccentColorTable())
    importExportFrame:EnableMouse(true)
    importExportFrame:SetFrameStrata("DIALOG")
    importExportFrame:SetFrameLevel(Cell.frames.raidDebuffsTab:GetFrameLevel()+20)
    P:Size(importExportFrame, 430, 170)
    importExportFrame:SetPoint("TOPLEFT", P:Scale(1), -100)
    if not Cell.frames.raidDebuffsTab.mask then
        Cell:CreateMask(Cell.frames.raidDebuffsTab, nil, {1, -1, -1, 1})
        Cell.frames.raidDebuffsTab.mask:Hide()
    end

    -- close
    local closeBtn = Cell:CreateButton(importExportFrame, "×", "red", {18, 18}, false, false, "CELL_FONT_SPECIAL", "CELL_FONT_SPECIAL")
    closeBtn:SetPoint("TOPRIGHT", -5, -1)
    closeBtn:SetScript("OnClick", function() importExportFrame:Hide() end)
    
    -- title
    title = importExportFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    title:SetPoint("TOPLEFT", 5, -5)
    
    -- instance name
    instance = importExportFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    instance:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -5)
    
    -- boss name
    boss = importExportFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    boss:SetPoint("TOPLEFT", instance, "BOTTOMLEFT", 0, -5)
    
    -- which bosses
    whichBossesBtn = Cell:CreateButton(importExportFrame, L["Current Boss"], "blue", {111, 18})
    whichBossesBtn:SetPoint("TOPRIGHT", closeBtn, "TOPLEFT", 1, 0)
    whichBossesBtn:Hide()
    whichBossesBtn:SetScript("OnClick", function()
        exportedAllBosses = not exportedAllBosses
        if exportedAllBosses then
            whichBossesBtn:SetText(L["All Bosses"])
            boss:SetText(L["Boss Name"]..": |cffffffff"..L["All Bosses"])
            ShowData(currentInstanceId)
        else
            whichBossesBtn:SetText(L["Current Boss"])
            boss:SetText(L["Boss Name"]..": |cffffffff"..currentBossName)
            ShowData(currentInstanceId, currentBossId)
        end
    end)
    
    -- import
    importBtn = Cell:CreateButton(importExportFrame, L["Import"], "green", {57, 18})
    importBtn:Hide()
    importBtn:SetPoint("TOPRIGHT", closeBtn, "TOPLEFT", 1, 0)
    importBtn:SetScript("OnClick", function()
        -- lower frame level
        importExportFrame:SetFrameStrata("HIGH")
    
        local text = L["This will overwrite your debuffs"].."\n"..
            L["|cff1Aff1AYes|r - Overwrite"].."\n|cffff1A1A"..L["No"].."|r - "..L["Cancel"]
        local popup = Cell:CreateConfirmPopup(Cell.frames.raidDebuffsTab, 200, text, function(self)
            local instanceName, bossName = F:GetInstanceAndBossName(imported["instanceId"], imported["bossId"])
            local which
            if bossName then
                which = bossName.." ("..instanceName..")"
            else
                which = instanceName
            end
            F:UpdateRaidDebuffs(imported["instanceId"], imported["bossId"], imported["data"], which)
            F:ShowInstanceDebuffs(imported["instanceId"], imported["bossId"])
            importExportFrame:Hide()
        end, function(self)
            importExportFrame:Hide()
        end, true)
        popup:SetPoint("TOPLEFT", importExportFrame, 117, -50)
    end)
    
    -- textArea
    textArea = Cell:CreateScrollEditBox(importExportFrame, function(eb, userChanged)
        if userChanged then
            if isImport then
                wipe(imported)
                local text = eb:GetText()
                -- check
                local version, instanceId, bossId, data = string.match(text, "^!CELL:(%d+):DEBUFF:(%d+):(.+)!(.+)$")
                
                local error
                if version and instanceId and bossId and data then
                    version = tonumber(version)
                    instanceId = tonumber(instanceId)
    
                    local isValidBossId
                    if bossId == "all" then
                        bossId = nil
                        isValidBossId = true
                    elseif bossId == "general" then
                        isValidBossId = true
                    else
                        bossId = tonumber(bossId)
                        if bossId then isValidBossId = true end
                    end
    
                    local instanceName, bossName = F:GetInstanceAndBossName(instanceId, bossId)
                    
                    if isValidBossId and instanceName then
                        if version >= Cell.MIN_DEBUFFS_VERSION then
                            local success
                            data = LibDeflate:DecodeForPrint(data) -- decode
                            success, data = pcall(LibDeflate.DecompressDeflate, LibDeflate, data) -- decompress
                            success, data = Serializer:Deserialize(data) -- deserialize
                            
                            if success and data then
                                local builtIn, custom = F:CalcRaidDebuffs(instanceId, bossId, data)
                                title:SetText(L["Import"]..": ".."|cff90EE90"..builtIn.." "..L["built-in(s)"].."|r, |cffFFB5C5"..custom.." "..L["custom(s)"].."|r")
                                
                                instance:SetText(L["Instance Name"]..": |cffffffff"..instanceName)
                                boss:SetText(L["Boss Name"]..": |cffffffff"..(bossName or L["All Bosses"]))
                                
                                imported["instanceId"] = instanceId
                                imported["bossId"] = bossId
                                imported["data"] = data
                                importBtn:SetEnabled(true)
                            else
                                error = L["Error"]
                            end
                        else -- incompatible version
                            error = L["Incompatible Version"]
                        end
                    else
                        error = L["Error"]
                    end
                else
                    error = L["Error"]
                end
    
                if error then
                    title:SetText(L["Import"]..": |cffff2222"..error)
                    instance:SetText(L["Instance Name"]..": |cffff2222"..L["Error"])
                    boss:SetText(L["Boss Name"]..": |cffff2222"..L["Error"])
                    importBtn:SetEnabled(false)
                end
            else
                eb:SetText(exported)
                eb:SetCursorPosition(0)
                eb:HighlightText()
            end
        end
    end)
    Cell:StylizeFrame(textArea.scrollFrame, {0, 0, 0, 0}, Cell:GetAccentColorTable())
    textArea:SetPoint("TOPLEFT", 5, -60)
    textArea:SetPoint("BOTTOMRIGHT", -5, 5)
    
    -- highlight text
    textArea.eb:SetScript("OnEditFocusGained", function() textArea.eb:HighlightText() end)
    textArea.eb:SetScript("OnMouseUp", function()
        if not isImport then
            textArea.eb:HighlightText()
        end
    end)
    
    importExportFrame:SetScript("OnHide", function()
        importExportFrame:Hide()
        isImport = false
        exported = ""
        wipe(imported)
        Cell.frames.raidDebuffsTab.mask:Hide()
    end)
    
    importExportFrame:SetScript("OnShow", function()
        -- raise frame level
        importExportFrame:SetFrameStrata("DIALOG")
        Cell.frames.raidDebuffsTab.mask:Show()
    end)
end

local init
function F:ShowRaidDebuffsImportFrame()
    if not init then
        init = true    
        CreateDebuffsImportExportFrame()
    end

    importExportFrame:Show()
    isImport = true
    importBtn:Show()
    importBtn:SetEnabled(false)
    whichBossesBtn:Hide()

    exported = ""
    title:SetText(L["Import"])
    instance:SetText(L["Instance Name"])
    boss:SetText(L["Boss Name"])
    textArea:SetText("")
    textArea.eb:SetFocus(true)
end

ShowData = function(instanceId, bossId)
    local data
    if not bossId then -- all bosses
        if CellDB["raidDebuffs"][instanceId] then
            data = CellDB["raidDebuffs"][instanceId]
        end
    else
        if CellDB["raidDebuffs"][instanceId] and CellDB["raidDebuffs"][instanceId][bossId] then
            data = CellDB["raidDebuffs"][instanceId][bossId]
        end
    end

    if data then
        local builtIn, custom = F:CalcRaidDebuffs(instanceId, bossId, data)
        title:SetText(L["Export"]..": ".."|cff90EE90"..builtIn.." "..L["built-in(s)"].."|r, |cffFFB5C5"..custom.." "..L["custom(s)"].."|r")

        local prefix = "!CELL:"..Cell.versionNum..":DEBUFF:"..instanceId..":"..(bossId or "all").."!"
        exported = Serializer:Serialize(data) -- serialize
        exported = LibDeflate:CompressDeflate(exported, deflateConfig) -- compress
        exported = LibDeflate:EncodeForPrint(exported) -- encode
        exported = prefix..exported
    else
        title:SetText(L["Export"]..": ")
        exported = L["No custom debuffs to export!"]
    end

    textArea:SetText(exported)
    textArea.eb:SetFocus(true)
end

function F:ShowRaidDebuffsExportFrame(instanceId, bossId)
    if not init then
        init = true    
        CreateDebuffsImportExportFrame()
    end

    importExportFrame:Show()
    isImport = false
    importBtn:Hide()
    exportedAllBosses = false
    whichBossesBtn:SetText(L["Current Boss"])
    whichBossesBtn:Show()

    local instanceName, bossName = F:GetInstanceAndBossName(instanceId, bossId)
    currentInstanceId = instanceId
    currentBossId = bossId
    currentBossName = bossName

    title:SetText(L["Export"]..": ")
    instance:SetText(L["Instance Name"]..": |cffffffff"..instanceName)
    boss:SetText(L["Boss Name"]..": |cffffffff"..bossName)

    ShowData(instanceId, bossId)
end