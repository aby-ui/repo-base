local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local Serializer = LibStub:GetLibrary("LibSerialize")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local deflateConfig = {level = 9}

local isImport, imported, exported = false, nil, ""

local importExportFrame, importBtn, title, textArea, includeNicknamesCB

local function GetExportString(includeNicknames)
    local prefix = "!"..CELL_IMPORT_EXPORT_PREFIX..":"..(tonumber(string.match(Cell.version, "%d+")) or 0).."!"

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
            L["|cff1Aff1AYes|r - Overwrite"].."\n".."|cffff1A1A"..L["No"].."|r - "..L["Cancel"]
        local popup = Cell:CreateConfirmPopup(Cell.frames.aboutTab, 200, text, function(self)
            -- !overwrite
            CellDB = imported
            ReloadUI()
        end, function()
            importExportFrame:Hide()
        end, true)
        popup:SetPoint("TOPLEFT", importExportFrame, 117, -50)
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
                local version, data = string.match(text, "^!"..CELL_IMPORT_EXPORT_PREFIX..":(%d+)!(.+)$")
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