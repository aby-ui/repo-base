local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local Serializer = LibStub:GetLibrary("LibSerialize")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local deflateConfig = {level = 9}

local isImport, imported, exported = false, nil, ""

local importExportFrame, importBtn, title, textArea, includeNicknamesCB

local function DoImport()
    -- raid debuffs
    for instanceID in pairs(imported["raidDebuffs"]) do
        if not Cell.snippetVars.loadedDebuffs[instanceID] then
            imported["raidDebuffs"][instanceID] = nil
        end
    end

    -- remove invalid
    if Cell.isRetail then
        imported["appearance"]["useLibHealComm"] = false
    elseif Cell.isWrath then
        imported["layoutAutoSwitch"] = nil
        imported["cleuAuras"] = nil
        imported["cleuGlow"] = nil
        imported["appearance"]["healAbsorb"][1] = false
    end

    -- indicators
    local builtInFound = {}
    for _, layout in pairs(imported["layouts"]) do
        for i =  #layout["indicators"], 1, -1 do
            if layout["indicators"][i]["type"] == "built-in" then -- remove unsupported built-in
                local indicatorName = layout["indicators"][i]["indicatorName"]
                builtInFound[indicatorName] = true
                if not Cell.defaults.indicatorIndices[indicatorName] then
                    tremove(layout["indicators"], i)
                end
            else -- remove invalid spells from custom indicators
                F:FilterInvalidSpells(layout["indicators"][i]["auras"])
            end
        end        
    end

    -- add missing indicators
    if F:Getn(builtInFound) ~= Cell.defaults.builtIns then
        for indicatorName, index in pairs(Cell.defaults.indicatorIndices) do
            if not builtInFound[indicatorName] then
                for _, layout in pairs(imported["layouts"]) do
                    tinsert(layout["indicators"], index, Cell.defaults.layout.indicators[index])
                end
            end
        end
    end

    -- click-castings
    if Cell.isRetail then
        for class, t in pairs(imported["clickCastings"]) do
            -- remove
            t[1] = nil
            t[2] = nil
            t["alwaysTargeting"][1] = nil
            t["alwaysTargeting"][2] = nil
            -- add
            local classID = F:GetClassID(class)
            for sepcIndex = 1, GetNumSpecializationsForClassID(classID) do
                local specID = GetSpecializationInfoForClassID(classID, sepcIndex)
                if not t["alwaysTargeting"][specID] then
                    t["alwaysTargeting"][specID] = "disabled"
                end
                if not t[specID] then
                    t[specID] = {
                        {"type1", "target"},
                        {"type2", "togglemenu"},
                    } 
                end
            end
        end
    elseif Cell.isWrath then
        for class, t in pairs(imported["clickCastings"]) do
            -- remove
            for k in pairs(t) do
                if k ~= "useCommon" and k ~= "alwaysTargeting" and k ~= "common" and k ~= 1 and k ~= 2 then
                    t[k] = nil
                end
            end
            for k in pairs(t["alwaysTargeting"]) do
                if k ~= "common" and k ~= 1 and k ~= 2 then
                    t["alwaysTargeting"][k] = nil
                end
            end
            -- add
            if not t["alwaysTargeting"][1] then
                t["alwaysTargeting"][1] = "disabled"
            end
            if not t["alwaysTargeting"][2] then
                t["alwaysTargeting"][2] = "disabled"
            end
            if not t[1] then
                t[1] = {
                    {"type1", "target"},
                    {"type2", "togglemenu"},
                }
            end
            if not t[2] then
                t[2] = {
                    {"type1", "target"},
                    {"type2", "togglemenu"},
                }
            end
        end
    end

    -- remove invalid
    F:FilterInvalidSpells(imported["debuffBlacklist"])
    F:FilterInvalidSpells(imported["bigDebuffs"])
    F:FilterInvalidSpells(imported["consumables"])
    F:FilterInvalidSpells(imported["customDefensives"])
    F:FilterInvalidSpells(imported["customExternals"])
    F:FilterInvalidSpells(imported["targetedSpellsList"])
    F:FilterInvalidSpells(imported["cleuAuras"])

    -- disable autorun for all snippets
    for _, t in pairs(imported["snippets"]) do
        t["autorun"] = false
    end

    -- texplore(imported)

    --! overwrite
    CellDB = imported
    ReloadUI()
end

local function GetExportString(includeNicknames)
    local prefix = "!CELL:"..Cell.versionNum..":ALL!"

    local db = F:Copy(CellDB)
    
    if not includeNicknames then
        db["nicknames"] = nil
    end

    local str = Serializer:Serialize(db) -- serialize
    str = LibDeflate:CompressDeflate(str, deflateConfig) -- compress
    str = LibDeflate:EncodeForPrint(str) -- encode

    return prefix..str
end

local function CreateImportExportFrame()
    importExportFrame = CreateFrame("Frame", "CellOptionsFrame_ImportExport", Cell.frames.aboutTab, "BackdropTemplate")
    importExportFrame:Hide()
    Cell:StylizeFrame(importExportFrame, nil, Cell:GetAccentColorTable())
    importExportFrame:EnableMouse(true)
    importExportFrame:SetFrameStrata("DIALOG")
    importExportFrame:SetFrameLevel(Cell.frames.aboutTab:GetFrameLevel()+20)
    P:Size(importExportFrame, 430, 170)
    importExportFrame:SetPoint("BOTTOMLEFT", P:Scale(1), 27)
    
    if not Cell.frames.aboutTab.mask then
        Cell:CreateMask(Cell.frames.aboutTab, nil, {1, -1, -1, 1})
        Cell.frames.aboutTab.mask:Hide()
    end

    -- close
    local closeBtn = Cell:CreateButton(importExportFrame, "×", "red", {18, 18}, false, false, "CELL_FONT_SPECIAL", "CELL_FONT_SPECIAL")
    closeBtn:SetPoint("TOPRIGHT", P:Scale(-5), P:Scale(-1))
    closeBtn:SetScript("OnClick", function() importExportFrame:Hide() end)

    -- import
    importBtn = Cell:CreateButton(importExportFrame, L["Import"], "green", {57, 18})
    importBtn:Hide()
    importBtn:SetPoint("TOPRIGHT", closeBtn, "TOPLEFT", P:Scale(1), 0)
    importBtn:SetScript("OnClick", function()
        -- lower frame level
        importExportFrame:SetFrameStrata("HIGH")
    
        local text = "|cFFFF7070"..L["All Cell settings will be overwritten!"].."|r\n"..
            "|cFFB7B7B7"..L["Autorun will be disabled for all code snippets"].."|r\n"..
            L["|cff1Aff1AYes|r - Overwrite"].."\n".."|cffff1A1A"..L["No"].."|r - "..L["Cancel"]
        local popup = Cell:CreateConfirmPopup(Cell.frames.aboutTab, 200, text, function(self)
            DoImport()
        end, function()
            importExportFrame:Hide()
        end, true)
        popup:SetPoint("TOPLEFT", importExportFrame, 117, -20)
    end)
    
    -- title
    title = importExportFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    title:SetPoint("TOPLEFT", 5, -5)

    -- export include nickname settings
    includeNicknamesCB = Cell:CreateCheckButton(importExportFrame, L["Include Nickname Settings"], function(checked)
        exported = GetExportString(checked)
        textArea:SetText(exported)
    end)
    includeNicknamesCB:SetPoint("TOPLEFT", 5, -25)
    includeNicknamesCB:Hide()
    
    -- textArea
    textArea = Cell:CreateScrollEditBox(importExportFrame, function(eb, userChanged)
        if userChanged then
            if isImport then
                imported = nil
                local text = eb:GetText()
                -- check
                local version, data = string.match(text, "^!CELL:(%d+):ALL!(.+)$")
                version = tonumber(version)
    
                if version and data then
                    if version >= Cell.MIN_VERSION then
                        local success
                        data = LibDeflate:DecodeForPrint(data) -- decode
                        success, data = pcall(LibDeflate.DecompressDeflate, LibDeflate, data) -- decompress
                        success, data = Serializer:Deserialize(data) -- deserialize
                        
                        if success and data then
                            title:SetText(L["Import"]..": r"..version)
                            importBtn:SetEnabled(true)
                            imported = data
                        else
                            title:SetText(L["Import"]..": |cffff2222"..L["Error"])
                            importBtn:SetEnabled(false)
                        end
                    else -- incompatible version
                        title:SetText(L["Import"]..": |cffff2222"..L["Incompatible Version"])
                        importBtn:SetEnabled(false)
                    end
                else
                    title:SetText(L["Import"]..": |cffff2222"..L["Error"])
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
    textArea:SetPoint("TOPLEFT", 5, -20)
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
        imported = nil
        -- hide mask
        Cell.frames.aboutTab.mask:Hide()
    end)
    
    importExportFrame:SetScript("OnShow", function()
        -- raise frame level
        importExportFrame:SetFrameStrata("DIALOG")
        Cell.frames.aboutTab.mask:Show()
    end)
end

local init
function F:ShowImportFrame()
    if not init then
        init = true    
        CreateImportExportFrame()
    end

    importExportFrame:Show()
    isImport = true
    importBtn:Show()
    importBtn:SetEnabled(false)

    exported = ""
    title:SetText(L["Import"])
    textArea:SetText("")
    textArea.eb:SetFocus(true)

    includeNicknamesCB:Hide()
    textArea:SetPoint("TOPLEFT", 5, -20)
    P:Height(importExportFrame, 170)
end

function F:ShowExportFrame()
    if not init then
        init = true    
        CreateImportExportFrame()
    end

    importExportFrame:Show()
    isImport = false
    importBtn:Hide()

    title:SetText(L["Export"]..": "..Cell.version)

    exported = GetExportString(false)

    textArea:SetText(exported)
    textArea.eb:SetFocus(true)

    includeNicknamesCB:SetChecked(false)
    includeNicknamesCB:Show()
    textArea:SetPoint("TOPLEFT", 5, -50)
    P:Height(importExportFrame, 200)
end