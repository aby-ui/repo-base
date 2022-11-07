local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local Serializer = LibStub:GetLibrary("LibSerialize")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local deflateConfig = {level = 9}

local isImport, imported, exported = false, {}, ""

local importExportFrame, importBtn, title, textArea

local function CreateLayoutImportExportFrame()
    importExportFrame = CreateFrame("Frame", "CellOptionsFrame_LayoutsImportExport", Cell.frames.layoutsTab, "BackdropTemplate")
    importExportFrame:Hide()
    Cell:StylizeFrame(importExportFrame, nil, Cell:GetAccentColorTable())
    importExportFrame:EnableMouse(true)
    importExportFrame:SetFrameStrata("DIALOG")
    importExportFrame:SetFrameLevel(Cell.frames.layoutsTab:GetFrameLevel()+20)
    P:Size(importExportFrame, 430, 170)
    importExportFrame:SetPoint("TOPLEFT", P:Scale(1), -100)
    
    if not Cell.frames.layoutsTab.mask then
        Cell:CreateMask(Cell.frames.layoutsTab, nil, {1, -1, -1, 1})
        Cell.frames.layoutsTab.mask:Hide()
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
    
        if CellDB["layouts"][imported["name"]] then
            local text = L["Overwrite Layout"]..": "..(imported["name"] == "default" and _G.DEFAULT or imported["name"]).."?\n"..
                L["|cff1Aff1AYes|r - Overwrite"].."\n"..L["|cffff1A1ANo|r - Create New"]
            local popup = Cell:CreateConfirmPopup(Cell.frames.layoutsTab, 200, text, function(self)
                -- !overwrite
                local name = imported["name"]
                CellDB["layouts"][name] = imported["data"]
                Cell:Fire("LayoutImported", name)
                importExportFrame:Hide()
            end, function(self)
                -- !create new
                local name
                local i = 2
                repeat
                    name = imported["name"].." "..i
                    i = i + 1
                until not CellDB["layouts"][name]
    
                CellDB["layouts"][name] = imported["data"]
                Cell:Fire("LayoutImported", name)
                importExportFrame:Hide()
            end, true)
            popup:SetPoint("TOPLEFT", importExportFrame, 117, -50)
        else
            -- !new
            local name = imported["name"]
            CellDB["layouts"][name] = imported["data"]
            Cell:Fire("LayoutImported", name)
            importExportFrame:Hide()
        end
    end)
    
    -- title
    title = importExportFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    title:SetPoint("TOPLEFT", 5, -5)
    
    -- textArea
    textArea = Cell:CreateScrollEditBox(importExportFrame, function(eb, userChanged)
        if userChanged then
            if isImport then
                wipe(imported)
                local text = eb:GetText()
                -- check
                local version, name, data = string.match(text, "^!"..CELL_IMPORT_EXPORT_PREFIX..":(%d+):([^:]+)!(.+)$")
                version = tonumber(version)
    
                if name and version and data then
                    if version >= Cell.MIN_LAYOUTS_VERSION then
                        local success
                        data = LibDeflate:DecodeForPrint(data) -- decode
                        success, data = pcall(LibDeflate.DecompressDeflate, LibDeflate, data) -- decompress
                        success, data = Serializer:Deserialize(data) -- deserialize
                        
                        if success and data then
                            title:SetText(L["Import"]..": "..(name == "default" and _G.DEFAULT or name))
                            importBtn:SetEnabled(true)
                            imported["name"] = name
                            imported["data"] = data
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
    textArea:SetPoint("TOPLEFT", P:Scale(5), P:Scale(-20))
    textArea:SetPoint("BOTTOMRIGHT", P:Scale(-5), P:Scale(5))
    
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
        -- hide mask
        Cell.frames.layoutsTab.mask:Hide()
    end)
    
    importExportFrame:SetScript("OnShow", function()
        -- raise frame level
        importExportFrame:SetFrameStrata("DIALOG")
        Cell.frames.layoutsTab.mask:Show()
    end)
end

local init
function F:ShowLayoutImportFrame()
    if not init then
        init = true    
        CreateLayoutImportExportFrame()
    end

    importExportFrame:Show()
    isImport = true
    importBtn:Show()
    importBtn:SetEnabled(false)

    exported = ""
    title:SetText(L["Import"])
    textArea:SetText("")
    textArea.eb:SetFocus(true)
end

function F:ShowLayoutExportFrame(layoutName, layoutTable)
    if not init then
        init = true    
        CreateLayoutImportExportFrame()
    end

    importExportFrame:Show()
    isImport = false
    importBtn:Hide()

    title:SetText(L["Export"]..": "..(layoutName == "default" and _G.DEFAULT or layoutName))

    local prefix = "!"..CELL_IMPORT_EXPORT_PREFIX..":"..(tonumber(string.match(Cell.version, "%d+")) or 0)..":"..layoutName.."!"

    exported = Serializer:Serialize(layoutTable) -- serialize
    exported = LibDeflate:CompressDeflate(exported, deflateConfig) -- compress
    exported = LibDeflate:EncodeForPrint(exported) -- encode
    exported = prefix..exported

    textArea:SetText(exported)
    textArea.eb:SetFocus(true)
end